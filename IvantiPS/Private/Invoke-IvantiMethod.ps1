function Invoke-IvantiMethod {
<#
.SYNOPSIS
    Call the Ivanti Service Manager (ISM) end point. This is used by other functions, and is not meant to be called directly.

.DESCRIPTION
    Call the Ivanti Service Manager (ISM) end point. This is used by other functions, and is not meant to be called directly.

.PARAMETER URI
    URI for the ISM end point

.PARAMETER Method
    Method to use. Must be a valid Web Request Method. Defaults to GET

.PARAMETER Headers
    Headers to include with the request

.PARAMETER GetParameter
    Get parameters to append to the URI.

.PARAMETER Level
    Indicates level of recursion

.NOTES
    https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Authentication_of_APIs.htm

#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Uri]$URI,
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = "GET",
        [Hashtable]$Headers,
        [Hashtable]$GetParameter = @{},
        [System.Object]$Body,
        [int]$Level = 1
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function started. PSBoundParameters: $($PSBoundParameters | Out-String)"
#region Headers
        # Construct the Headers with the following priority:
        # - Headers passes as parameters
        # - Module's default Headers
        #
        $session = Get-IvantiSession
        if (-not $session) {
            Write-Warning "[$($MyInvocation.MyCommand.Name) $Level] Must first establish session with Connect-IvantiTenant. Exiting..."
            break
        }
        $AuthHeader = @{Authorization = $Session}
        # If headers hash was passed in, join with auth header
        #
        if ($Headers) {
            $_headers = Join-Hashtable -Hashtable $Headers, $AuthHeader
        } else {
            $_headers = $AuthHeader
        }
#endregion Headers

#region Manage URI
        # Amend query from URI with GetParameter
        $uriQuery = ConvertTo-ParameterHash -Uri $Uri
        $internalGetParameter = Join-Hashtable $uriQuery, $GetParameter

        # Use default 100 for top records, unless top parm is used
        #
        if (-not $internalGetParameter.ContainsKey('$top')) {
            $internalGetParameter['$top'] = 100
        }

        # remove URL from from URI
        #
        [Uri]$Uri = $Uri.GetLeftPart("Path")
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Left portion of URI: [$uri]"
        $PaginatedUri = $Uri
        [Uri]$PaginatedUri = "{0}{1}" -f $PaginatedUri, (ConvertTo-GetParameter $internalGetParameter)

#endregion Manage URI

#region Construct IRM Parameter
        $splatParameters = @{
            Uri             = $PaginatedUri
            Method          = $Method
            Headers         = $_headers
            ErrorAction     = "Stop"
            Verbose         = $false
        }
        if ($body) {
            Write-Debug "[$($MyInvocation.MyCommand.Name) $LevelOfRecursion] Added body to splatparm: $($body | Out-String)"
            $splatParameters += @{
                Body = $body
            }
        }
#endregion Constructe IRM Parameter

#region Execute the actual query
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] $($splatParameters.Method) $($splatParameters.Uri)"
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Invoke-RestMethod with `$splatParameters: $($splatParameters | Out-String)"
            # Invoke the API
            #
            $RestResponse = Invoke-RestMethod @splatParameters
        }
        catch {
            Write-Warning "[$($MyInvocation.MyCommand.Name) $Level] Failed to get answer"
            Write-Warning "[$($MyInvocation.MyCommand.Name) $Level] URI: $($splatParameters.Uri)"
            $_
        }

        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Executed RestMethod"

        # Test to see if there was an error code in the
        # response from invoke-restmethod
        #
        Test-ServerResponse -InputObject $Response
#endregion Execute the actual query
    } # End begin

    process {
        if ($RestResponse) {
            # Value should have the data. If not, then just dump whatever was returned to pipeline
            #
            if (-not $RestResponse.Value) {
                $RestResponse
            } else {
                $result = $RestResponse.Value
                Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] (`$response).Count: $(($result).Count)"

                # The @odata.count property has the total number records
                #
                $ODataCount = $RestResponse."@odata.count"
                Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] ODataCount: $ODataCount"

                if ($GetParameter) {
                    if ($GetParameter['$top']) {
                        $top = $GetParameter['$top']
                    }
                    if ($GetParameter['$skip']) {
                        $skip = $GetParameter['$skip']
                    }
                }
                $TopPlusSkip = $top + $skip

                Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] TopPlusSkip: $TopPlusSkip"

                if ($TopPlusSkip -lt $ODataCount) {
                    $GetMore = $true
                    if (-not $top) {
                        $top = 100
                    }
                } else {
                    $GetMore = $false
                }
                Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] `$GetMore: $GetMore"

    #region paging
                if ($GetMore -eq $true) {
                    # Remove Parameters that don't need propagation
                    $null = $PSBoundParameters.Remove('$top')
                    $null = $PSBoundParameters.Remove('$skip')

                    if (-not $PSBoundParameters["GetParameter"]) {
                        $PSBoundParameters["GetParameter"] = $internalGetParameter
                    }

                    $total = 0
                    do {
                        $total += $result.Count

                        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Invoking pagination, [`$Total: $Total]"
                        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Output results [Level: $Level] [Results count: $(($result|Measure-Object).Count)]"

                        # Output results from this loop
                        $result

                        if ($Total -ge $ODataCount) {
                            Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Stopping paging, as [`$Total: $Total] reached [`$ODataAcount: $ODataCount]"
                            return
                        } else {
                            Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Continuing paging, as [`$Total: $Total] has not reached [`$ODataAcount: $ODataCount]"
                        }

                        # calculate the size of the next page
                        $PSBoundParameters["GetParameter"]['$skip'] = $Total + $skip
                        $expectedTotal = $PSBoundParameters["GetParameter"]['$skip'] + $top
                        if ($expectedTotal -gt $ODataCount) {
                            $reduceBy = $expectedTotal - $ODataCount
                            $PSBoundParameters["GetParameter"]['$top'] = $top - $reduceBy
                        }

                        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] URI: $($PSBoundParameters["Uri"])"
                        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] GetParameter top: $($PSBoundParameters["GetParameter"]['$top'])"
                        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] GetParameter skip: $($PSBoundParameters["GetParameter"]['$skip'])"

                        # increment the recursion level for debugging
                        $PSBoundParameters["Level"] = $Level + 1

                        # Get the next page aka recurse
                        $result = Invoke-IvantiMethod @PSBoundParameters
                    } while ($result.Count -gt 0)
    #endregion paging
                } else {
                    Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Final output results [$(($result | Measure-Object).Count)]"
                    $result
                }
            }
        } else {
            Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] No Web result object was returned"
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] `$RestResponse was empty"
        }
    }

    end {
        #Set-TlsLevel -Revert

        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function ended"
    }
}

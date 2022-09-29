function Get-IvantiBusinessObjectMetadata {
<#
.SYNOPSIS
    Get the metadata for an Ivanti Business Object

.DESCRIPTION
    Get the metadata for an Ivanti Business Object

.PARAMETER BusinessObject
    A business object to get meta data for. Example value: agency

.PARAMETER MetaDatatype
    The type of meta data to return. May be Fields, Relationships, Actions, or SavedSearch

.EXAMPLE
    Get-IvantiBusinessObjectMetadata -BusinessObject incident -MetaDataType Actions

    Get the quick actions related to incident business object type

.NOTES
    https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Metadata.htm
    https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Saved-Search-API.htm
    https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Quick-Actions-API.htm

#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification='Yes, Metadata is plural. technically. but really?!?!?')]
    param(
        [Parameter(Mandatory)]
        [string]$BusinessObject,
        [Parameter(Mandatory)]
        [ValidateSet('Fields','Relationships','Actions','SavedSearch')]
        [string]$MetaDataType
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function started PSBoundParameters: $($PSBoundParameters | Out-String)"

        $tenant = (Get-IvantiPSConfig).IvantiTenantID

        $session = Get-IvantiSession
        if (-not $session) {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] No Ivanti session available. Exiting..."
            break
        }
        $headers = @{Authorization = $Session}

        # like this https://tenant.ivanticloud.com/api/odata/agencys/$metadata
        #
        $uri = "https://{0}/api/odata/{1}s/`$metadata" -f $tenant, $BusinessObject

        $splatParameters = @{
            Uri             = $Uri
            Method          = 'GET'
            Headers         = $headers
            ErrorAction     = "Stop"
        }

        try {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Invoke-RestMethod with `$splatParameters: $($splatParameters | Out-String)"
            # Invoke rest method
            #
            $Response = Invoke-RestMethod @splatParameters
        }
        catch {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] Failed to get answer"
            Write-Warning "[$($MyInvocation.MyCommand.Name)] URI: $($splatParameters.Uri)"
            $_
        }
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Executed RestMethod"
    } # End begin

    process {
        if ($Response) {

            switch ($MetaDataType) {
                'Fields' {
                    $Response.Edmx.DataServices.Schema.EntityType |
                        Where-Object {$_.Name -eq $BusinessObject} |
                        Select-Object -ExpandProperty Property
                }
                'Relationships' {
                    $Response.Edmx.DataServices.Schema.EntityType |
                        Where-Object {$_.Name -eq $BusinessObject} |
                        Select-Object -ExpandProperty NavigationProperty |
                        Select-Object Name,Type
                }
                'Actions' {
                    $Response.Edmx.DataServices.Schema.Action |
                        Select-Object Name,@{
                            Name='ActionID';
                            Expression={
                                $null = $_.InnerXML -match 'String="([\w|-]*)" />';
                                $matches[1]
                            }
                        }
                }
                'SavedSearch' {
                    # More information on Saved Search
                    # https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Saved-Search-API.htm
                    $Response.Edmx.DataServices.Schema.Function |
                        Select-Object Name,@{
                            Name='ActionID';
                            Expression={
                                $null = $_.InnerXML -match 'String="([\w|-]*)" />';
                                $matches[1]
                            }
                        }
                }
                Default {
                    $Response
                }
            } # end switch
        } else {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] No results were returned"
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No results were returned"
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
}

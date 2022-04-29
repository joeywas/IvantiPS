function Get-IvantiBusinessObject {
    <#
    .SYNOPSIS
        Get business objects from Ivanti. Defaults to all.

    .DESCRIPTION
        Get business objects from Ivanti. Defaults to all.

    .PARAMETER BusinessObject
        Ivanti Business Object to return

    .EXAMPLE
        Get-IvantiBusinessObject -BusinessObject agency

    .EXAMPLE
        Get-IvantiBusinessObject -BusinessObject change

    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$BusinessObject,
        [string]$RecID
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        # Build the URL. It will look something like the below for agency business objects
        # Note the 's' at the end
        # https://tenant.ivanticloud.com/api/odata/businessobject/agencys
        #
        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID
        $uri = "https://{0}/api/odata/businessobject/{1}s" -f $IvantiTenantID,$BusinessObject

        if ($RecID) {
            $uri = "{0}('{1}')" -f $uri,$RecID
        }

    } # end begin

    process {
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] $uri"
        Invoke-IvantiMethod -URI $uri
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

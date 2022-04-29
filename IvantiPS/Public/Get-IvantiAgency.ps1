function Get-IvantiAgency {
    <#
    .SYNOPSIS
        Get Agency business objects from Ivanti. Defaults to all.

    .DESCRIPTION
        Get Agency business objects from Ivanti. Defaults to all.

    .PARAMETER RecID
        Ivanti Record ID for a specific Agency business object

    .PARAMETER Agency
        Full agency name to filter on

    .PARAMETER AgencyShortName
        Agency short name to filter on. Usually an abbreviation

    .EXAMPLE
        Get-IvantiAgency -AgencyShortName ACM

    .EXAMPLE
        Get-IvantiAgency -Agency 'Advanced Computer Machines'

    .EXAMPLE
        Get-IvantiAgency -RecID DC218F83EC504222B148EF1344E15BCB

    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm

    #>
    [CmdletBinding()]
    param(
        [string]$RecID,
        [string]$Agency,
        [string]$AgencyShortName
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        # If one or more parameters are passed in, use only one of them
        # Order of preference is RecID, Agency, then AgencyShortName
        # if no parameters are passed in, then do not set any get parameters
        #
        if ($RecID) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] RecID [$RecID] passed in, setting filter"
            $GetParameter = @{'$filter' = "RecID eq '$($RecID)'"}
        } elseif ($Agency) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Agency [$Agency] passed in, setting filter"
            $GetParameter = @{'$filter' = "Agency eq '$($Agency)'"}
        } elseif ($AgencyShortName) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] AgencyShortName [$AgencyShortName] passed in, setting filter"
            $GetParameter = @{'$filter' = "AgencyShortName eq '$($AgencyShortName)'"}
        } else {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No parameters passed in"
        }

        # Build the URL. It will look something like the below for agency business objects
        # Note the 's' at the end
        # https://tenant.ivanticloud.com/api/odata/businessobject/agencys
        #
        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID
        $uri = "https://$IvantiTenantID/api/odata/businessobject/agencys"

    } # end begin

    process {
        Invoke-IvantiMethod -URI $uri -GetParameter $GetParameter
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

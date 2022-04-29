function Get-IvantiEmployee {
    <#
    .SYNOPSIS
        Get Employee business objects from Ivanti. Defaults to all.

    .DESCRIPTION
        Get Employee business objects from Ivanti. Defaults to all.

    .PARAMETER RecID
        Ivanti Record ID for a specific Employee business object

    .PARAMETER Name
        Employee name, will filter against DisplayName property

    .PARAMETER Email
        Employee email to filter on.

    .PARAMETER AllFields
        Set this parameter if returning all fields is desired

    .EXAMPLE
        Get-IvantiEmployee -Email john.smith@domain.name

    .EXAMPLE
        Get-IvantiEmployee -Name 'John Smith'

    .EXAMPLE
        Get-IvantiEmployee -RecID DC218F83EC504222B148EF1344E15BCB -AllFields

    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm

    #>
    [CmdletBinding()]
    param(
        [string]$RecID,
        [string]$Name,
        [string]$Email,
        [switch]$AllFields
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        # If one or more parameters are passed in, use only one of them
        # Order of preference is RecID, Name, then Email
        # if no parameters are passed in, then do not set any get parameters
        #
        if ($RecID) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] RecID [$RecID] passed in, setting filter"
            $GetParameter = @{'$filter' = "RecID eq '$($RecID)'"}
        } elseif ($Name) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Name [$Name] passed in, setting filter"
            $GetParameter = @{'$filter' = "DisplayName eq '$($Name)'"}
        } elseif ($Email) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Email [$Email] passed in, setting filter"
            $GetParameter = @{'$filter' = "PrimaryEmail eq '$($Email)'"}
        } else {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No parameters passed in"
        }

        if (-not $AllFields) {
            # Select only specific fields because there are way too many
            #
            $GetParameter += @{'$select' = 'RecId, DisplayName, OREmployeeID, PrimaryEmail, ManagerEmail, Agency, IsManager, IsLDAPUserAccountEnabled, LockDate, LockType, LoginAttemptCount, Disabled, LastModBy, LastModDateTime, CreatedDateTime'}
        }
        # Build the URL. It will look something like the below for Employee business objects
        # Note the 's' at the end
        # https://tenant.ivanticloud.com/api/odata/businessobject/employees
        #
        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID
        $uri = "https://$IvantiTenantID/api/odata/businessobject/employees"

    } # end begin

    process {
        Invoke-IvantiMethod -URI $uri -GetParameter $GetParameter
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

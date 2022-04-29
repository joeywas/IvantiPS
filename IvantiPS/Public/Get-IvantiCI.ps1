function Get-IvantiCI {
    <#
    .SYNOPSIS
        Get CI (assets) business objects from Ivanti. Defaults to all.

    .DESCRIPTION
        Get CI (assets) business objects from Ivanti. Defaults to all.

    .PARAMETER RecID
        Ivanti Record ID for a specific CI business object

    .PARAMETER Name
        CI (Asset) Name to filter on

    .PARAMETER IPAddress
        IP Address to filter on

    .EXAMPLE
        Get-IvantiCI -Name wpdotsqll42

    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm

    #>
    [CmdletBinding()]
    [Alias('Get-IvantiAsset')]
    param(
        [string]$RecID,
        [string]$Name,
        [string]$IPAddress
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
        } elseif ($Name) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Agency [$Agency] passed in, setting filter"
            $GetParameter = @{'$filter' = "Name eq '$($Name)'"}
        } elseif ($IPAddress) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] AgencyShortName [$AgencyShortName] passed in, setting filter"
            $GetParameter = @{'$filter' = "IPAddress eq '$($IPAddress)'"}
        } else {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No parameters passed in"
        }

        # Select only specific fields because there are way too many
        #
        $GetParameter += @{'$select' = 'RecId, Name, IPAddress, Category, CIType, ivnt_AssetFullType, Status, AssignedDescription, ivnt_SelfServiceDescription, AssignedOS, ivnt_AssignedManufacturer, Model, SerialNumber, AssetTag, OSSWPatchMgtMethod, ScheduleRebootInterval, ivnt_Location, BuildingAndFloor, EquipmentLocation, LocationRegion, BillableCpu, BillableMemory'}

        # Build the URL. It will look something like the below for ci business objects
        # Note the 's' at the end
        # https://tenant.ivanticloud.com/api/odata/businessobject/cis
        #
        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID
        $uri = "https://$IvantiTenantID/api/odata/businessobject/cis"

    } # end begin

    process {
        Invoke-IvantiMethod -URI $uri -GetParameter $GetParameter
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

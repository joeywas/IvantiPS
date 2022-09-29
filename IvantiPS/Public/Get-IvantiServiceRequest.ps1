function Get-IvantiServiceRequest {
    <#
    .SYNOPSIS
        Get service request business objects from Ivanti.

    .DESCRIPTION
        Get service request business objects from Ivanti. Defaults to active service requests.

    .PARAMETER RecID
        Ivanti Record ID for a specific service request

    .PARAMETER AgencyName
        Filter to get service requests from a specific agency name

    .PARAMETER Status
        Status of the service requests to filter for. Set to All if wanting all Status values. Defaults to Active. 

        Valid values for Status
        ------
        All
        Closed
        Cancelled
        Fulfilled
        Active
        Waiting for Customer

    .PARAMETER AllFields
        If set, will return *all* available fields. Defaults to false. You've been warned!

    .EXAMPLE
        Get-IvantiServiceRequest -AgencyName ABC

        Returns all Active service requests for Agency with name ABC

    .EXAMPLE
        Get-IvantiServiceRequest -Status All

        Returns all ServiceRequests
        
    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Search.htm

    #>
    [CmdletBinding()]
    param(
        [string]$RecID,
        [string]$AgencyName,
        [ValidateSet('Closed','Active','Fulfilled','Cancelled','Waiting For Customer','All')]
        [string]$Status = 'Active',
        [switch]$AllFields = $false
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        # Build field list to select from so we don't get a bunch of extra fields we don't want
        #
        $fields = "RecID, ServiceReqNumber, Status, Subject, CreatedDateTime, CreatedBy, "
        $fields += "Service, Urgency, Priority, "
        $fields += "ImpactedAgenciesShort, Owner, OwnerTeam, OwnerTeamEmail, LastModDateTime, LastModBy, "
        $fields += "ResolvedDateTime, ResolvedBy, Resolution, BillingAgency, BillingAgencyNumber, ROParams"

        # If all fields is set, we don't both adding the fields to select
        # this will return *everything* available
        #
        if ($AllFields) {
            $GetParameter = @{}
        } else {
            $GetParameter = @{
                '$select' = $fields
            }
        }

        # If one or more parameters are passed in, use only one of them
        # Order of preference is RecID, Agency, then AgencyShortName
        # if no parameters are passed in, then do not set any get parameters
        #
        if ($RecID) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] RecID [$RecID] passed in, setting filter"
            $GetParameter += @{'$filter' = "RecID eq '$($RecID)'"}
        } elseif ($Status) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Status [$Status] set"
            if ($Status -eq 'All') {
                # Status is all, do not put a filter on things
            } else {
                $GetParameter += @{'$filter' = "Status eq '$($Status)'"}
            }
        } else {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No RecID or Status parameters passed in"
            $GetParameter += @{'$filter' = "Status eq 'Active'"}
        }

        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID

        if ($AgencyName) {
            # https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Related-Business-Objects-API.htm        
            $AgencyRecID = (Get-IvantiAgency -ShortName $AgencyName).RecID

            # Build the URL. It will look something like below for agency business object relationships
            # https://{tenant url}/api/odata/businessobject/{business object name}('{business object unique key}')/{relationship name}
            #
            $uri = "https://{0}/api/odata/businessobject/agencys('{1}')/ServiceReqAssocAgency" -f $IvantiTenantID,$AgencyRecID
        } else {
            # Build the URL. It will look something like the below for service request business objects
            # Note the 's' at the end
            # https://tenant.ivanticloud.com/api/odata/businessobject/servicereqs
            #
            $uri = "https://{0}/api/odata/businessobject/servicereqs" -f $IvantiTenantID
        }

    } # end begin

    process {
        Invoke-IvantiMethod -URI $uri -GetParameter $GetParameter
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

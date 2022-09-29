function Get-IvantiIncident {
    <#
    .SYNOPSIS
        Get incident business objects from Ivanti.

    .DESCRIPTION
        Get incident business objects from Ivanti. Defaults to active incidents.

    .PARAMETER RecID
        Ivanti Record ID for a specific incident

    .PARAMETER AgencyName
        Filter to get incidents from a specific agency name

    .PARAMETER Status
        Status of the incidents to filter for. Defaults to Active. Valid values: closed, resolved, cancelled, all

    .PARAMETER AllFields
        If set, will return *all* available fields. Defaults to false. You've been warned!

    .EXAMPLE
        Get-IvantiIncident -AgencyName ABC

        Returns all Active incidents for Agency with name ABC

    .EXAMPLE
        Get-IvantiIncident -Status All

        Returns all Active incidents

    .EXAMPLE
        Get-IvantiAgency -RecID DC218F83EC504222B148EF1344E15BCB

    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Search.htm

    #>
    [CmdletBinding()]
    param(
        [string]$RecID,
        [string]$AgencyName,
        [ValidateSet('Closed','Active','Resolved','Cancelled','All')]
        [string]$Status = 'Active',
        [switch]$AllFields = $false

    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        # Build field list to select from so we don't get a bunch of extra fields we don't want
        #
        $fields = "RecID, IncidentNumber, Status, Subject, CreatedDateTime, CreatedBy, "
        $fields += "Category, Subcategory, Service, Impact, Urgency, Priority, Vendor, "
        $fields += "ImpactedAgenciesShort, LastModDateTime, LastModBy, LastCustomerUpdate, "
        $fields += "ResolvedDateTime, ResolvedBy, Resolution, ResolutionCategory"

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
        }

        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID

        if ($AgencyName) {
            # https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Related-Business-Objects-API.htm
            $AgencyRecID = (Get-IvantiAgency -ShortName $AgencyName).RecID

            # relationship types that may be of interest
            # IncidentAssocAgency
            # ServiceReqAssocAgency
            # ChangeAssocAgency
            #
            #$RelationshipType = 'IncidentAssocAgency'

            # Build the URL. It will look something like below for agency business object relationships
            # https://{tenant url}/api/odata/businessobject/{business object name}('{business object unique key}')/{relationship name}
            #
            $uri = "https://{0}/api/odata/businessobject/agencys('{1}')/IncidentAssocAgency" -f $IvantiTenantID,$AgencyRecID
        } else {
            # Build the URL. It will look something like the below for incident business objects
            # Note the 's' at the end
            # https://tenant.ivanticloud.com/api/odata/businessobject/incidents
            #
            $uri = "https://$IvantiTenantID/api/odata/businessobject/incidents"
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

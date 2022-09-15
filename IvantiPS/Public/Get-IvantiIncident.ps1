function Get-IvantiIncident {
    <#
    .SYNOPSIS
        Get incident business objects from Ivanti.

    .DESCRIPTION
        Get incident business objects from Ivanti. Defaults to active incidents.

    .PARAMETER RecID
        Ivanti Record ID for a specific incident

    .PARAMETER Status
        Status of the incidents to filter for. Defaults to Active. Valid values: closed, resolved, cancelled, all

    .PARAMETER GetAllFields
        If set, will return *all* available fields. Defaults to false. You've been warned!

    .EXAMPLE
        Get-IvantiIncident

        Returns all Active incidents

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
        [ValidateSet('Closed','Active','Resolved','Cancelled','All')]
        [string]$Status = 'Active',
        [switch]$GetAllFields = $false

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

        if ($GetAllFields) {
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
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No parameters passed in"
        }

        # Build the URL. It will look something like the below for incident business objects
        # Note the 's' at the end
        # https://tenant.ivanticloud.com/api/odata/businessobject/incidents
        #
        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID
        $uri = "https://$IvantiTenantID/api/odata/businessobject/incidents"

    } # end begin

    process {
        Invoke-IvantiMethod -URI $uri -GetParameter $GetParameter
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

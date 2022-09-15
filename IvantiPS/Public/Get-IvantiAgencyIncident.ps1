function Get-IvantiAgencyIncident {
    <#
    .SYNOPSIS
        Get Incident business objects related to an Agency. Defaults to all.

    .DESCRIPTION
        Get Incident business objects related to an Agency. Defaults to all.

    .PARAMETER ShortName
        Agency short name to get incidents for

    .PARAMETER RecID
        Record ID for Agency to get incidents for

    .PARAMETER Status
        Status of the incidents to filter for. Defaults to Active. Valid values: closed, resolved, cancelled, all

    .PARAMETER GetAllFields
        If set, will return *all* available fields. Defaults to false. You've been warned!

    .EXAMPLE
        Get-IvantiAgencyIncidents ACM

        Returns all incidents for agency with short name value of ACM

    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Search.htm

    #>
    [CmdletBinding()]
    param(
        [Parameter(Position=0)]
        [string]$ShortName,
        [string]$RecID,
        [ValidateSet('Closed','Active','Resolved','Cancelled','All')]
        [string]$Status = 'Active',
        [switch]$GetAllFields = $false
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        # We need $RecID to get relationships
        #
        if ($RecID) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] RecID [$RecID] passed in"
        } elseif ($ShortName) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] ShortName [$ShortName] passed in, getting RecID"
            $RecID = (Get-IvantiAgency -ShortName $ShortName).RecID
        } else {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] No RecID or ShortName parameters passed in, returning..."
            Write-Warning "No RecID or ShortName parameters passed in, returning..."
            return
        }

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

        # Add filter to get parms if it is needed
        #
        if ($Status) {
            if ($Status -eq 'All') {
                # Status is all, do not put a filter on things
            } else {
                $GetParameter += @{'$filter' = "Status eq '$($Status)'"}
            }
        }
        
        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID
        $BusinessObject = 'agency'

        # relationship types that may be of interest
        #
        # IncidentAssocAgency
        # ServiceReqAssocAgency
        # ChangeAssocAgency
        #
        $RelationshipType = 'IncidentAssocAgency'

        # Build the URL. It will look something like below for agency business object relationships
        # https://{tenant url}/api/odata/businessobject/{business object name}('{business object unique key}')/{relationship name}
        #
        # ref https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Related-Business-Objects-API.htm        
        #
        $uri = "https://{0}/api/odata/businessobject/{1}s('{2}')/{3}" -f $IvantiTenantID,$BusinessObject,$RecID,$RelationshipType

    } # end begin

    process {
        # Abstraction?
        # Get-IvantiBusinessObjectRelationship -BusinessObject agency -RecID $recid -RelationshipType IncidentAssocAgency
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] $uri"
        Invoke-IvantiMethod -URI $uri -GetParameter $GetParameter
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function ended"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function ended"
    }
} # end function

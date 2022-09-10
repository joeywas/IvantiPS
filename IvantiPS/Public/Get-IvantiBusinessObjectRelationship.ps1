function Get-IvantiBusinessObjectRelationship {
<#
.SYNOPSIS
    Get related business objects from Ivanti

.DESCRIPTION
    Get related business objects from Ivanti

.PARAMETER BusinessObject
    Ivanti Business Object to return relationships for. e.g. agency, change, incident, servicereq, etc

.PARAMETER RecID
    The Record ID of the business object to get relationships for

.PARAMETER RelationshipType
    The Type of relationships to get

.EXAMPLE
    Get-IvantiBusinessObjectRelationship -BusinessObject agency -RecID '407A1A749C9347B59F47BD1D51061463' -RelationshipType 'AgencyAuthorizedApprovers'

.NOTES
    https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Related-Business-Objects-API.htm
#>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$BusinessObject,
        [string]$RecID,
        [string]$RelationshipType
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name) $Level] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name) $Level] Function Started. PSBoundParameters: $($PSBoundParameters | Out-String)"

        $IvantiTenantID = (Get-IvantiPSConfig).IvantiTenantID

        # Build the URL. It will look something like below for agency business object relationships
        # https://{tenant url}/api/odata/businessobject/{business object name}('{business object unique key}')/{relationship name}
        #
        $uri = "https://{0}/api/odata/businessobject/{1}s('{2}')/{3}" -f $IvantiTenantID,$BusinessObject,$RecID,$RelationshipType
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

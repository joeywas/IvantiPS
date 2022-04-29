function Test-ServerResponse {
    [CmdletBinding()]
    <#
        .SYNOPSIS
            Evaluate the response of the API call

        .LINK
            https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Session-ID-Log-In.htm

        .NOTES
            Thanks to Lipkau:
            https://github.com/AtlassianPS/JiraPS/blob/master/JiraPS/Private/Test-ServerResponse.ps1
    #>
    param (
        # Response of Invoke-WebRequest
        [Parameter( ValueFromPipeline )]
        [PSObject]$InputObject
    )

    begin {
    }

    process {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Checking response for error"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Checking response for error"

        if ($InputObject.Code) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Error code found, throwing error"
            throw ("{0}: {1}: {2}" -f $InputObject.Code,$InputObject.description,($InputObject.message -join ','))
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Done checking response for error"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Done checking response for error"
    }
}

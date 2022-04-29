function Write-DebugMessage {
    <#
    .SYNOPSIS
        Utility to write out debug message
    .NOTES
        Thanks Atlassian!
    #>
    [CmdletBinding()]
    param(
        [Parameter( ValueFromPipeline )]
        [String]$Message
    )

    begin {
        $oldDebugPreference = $DebugPreference
        if (-not ($DebugPreference -eq "SilentlyContinue")) {
            $DebugPreference = 'Continue'
        }
    }

    process {
        Write-Debug $Message
    }

    end {
        $DebugPreference = $oldDebugPreference
    }
}

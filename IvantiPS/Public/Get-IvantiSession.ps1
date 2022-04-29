function Get-IvantiSession {
<#
    .SYNOPSIS
        Get the session id from module's privatedata

    .DESCRIPTION
        Get the session id from module's privatedata

    .EXAMPLE
        Get-IvantiSession

#>
    [CmdletBinding()]
    param()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function started"
    }

    process {
        if ($MyInvocation.MyCommand.Module.PrivateData.Session) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Using Session saved in PrivateData"
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Using Session saved in PrivateData"
            Write-Output $MyInvocation.MyCommand.Module.PrivateData.Session
        } else {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] No session found in PrivateData. Use Connect-IvantiTenant first!"
        }
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function complete"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function complete"
    }
}

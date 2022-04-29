function Get-IvantiPSConfig {
<#
.SYNOPSIS
    Get default configurations for IvantiPS from config.json file

.DESCRIPTION
    Get default configurations for IvantiPS from config.json file

.EXAMPLE
    Get-IvantiPSConfig
#>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param ()

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function started"
        $config = "$([Environment]::GetFolderPath('ApplicationData'))\IvantiPS\config.json"
    }

    process {
        if ($config) {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Getting config from [$config]"
            [PSCustomObject](Get-Content -Path "$config" -ErrorAction Stop | ConvertFrom-Json)
        } else {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] No config found at [$config]"
            Write-Warning "[$($MyInvocation.MyCommand.Name)] Use Set-IvantiPSConfig first!"
            break
        }
    }
    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function complete"
    }
} # end function

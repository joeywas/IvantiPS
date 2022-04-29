function Set-IvantiPSConfig {
<#
.SYNOPSIS
    Set the URL, default Role, and Auth Type to use when connecting to Ivanti Service Manager

.DESCRIPTION
    Set the URL, default Role, and Auth Type to use when connecting to Ivanti Service Manager.
    Saves the information to IvantiPS/config.json file in user profile

.PARAMETER IvantiTenantID
    Ivanti Tenant ID for IvantiCloud tenant. example: tenantname.ivanticloud.com

.PARAMETER DefaultRole
    Default role to use to connect. Example values: Admin, SelfService, SelfServiceViewer

.PARAMETER AuthType
    Type of authentication to use to access ISM. SessionID, APIKey, or OIDC

.EXAMPLE
    Set-IvantiPSConfig -IvantiTenantID tenantname.ivanticloud.com -DefaultRole SelfService -AuthType SessionID

.NOTES
    https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Authentication_of_APIs.htm

#>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', 
        Justification='This function is trivial enough that we do not need ShouldProcess')]
    Param (
        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
		[Uri]$IvantiTenantID,
        [parameter(Mandatory)]
		[string]$DefaultRole,
        [parameter(Mandatory)]
		[string]$AuthType
    )
    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"

        #region configuration
        $configPath = "$([Environment]::GetFolderPath('ApplicationData'))\IvantiPS\config.json"
        Write-Verbose "Configuration will be stored in $($configPath)"
        #endregion configuration

        if (-not (Test-Path $configPath)) {
            # If the config file doesn't exist, created it
            $null = New-Item -Path $configPath -ItemType File -Force
        }
    }

    process {

        $config = [ordered]@{
            IvantiTenantID = $IvantiTenantID
            DefaultRole = $DefaultRole
            AuthType = $AuthType
        }

        $config | ConvertTo-Json | Set-Content -Path "$configPath"
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
    }
} # end function

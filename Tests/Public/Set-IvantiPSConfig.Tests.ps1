Describe 'Set-IvantiPSConfig' {

    BeforeAll {
        # Dot source import the function
        . "$((Split-Path $PSScriptRoot) -replace 'Tests','')IvantiPS\Public\Set-IvantiPSConfig.ps1"
    }
    
    It "Given valid parameters, creates config.json" {
        Set-IvantiPSConfig -IvantiTenantID testing.ivanticloud.com -DefaultRole SelfService -AuthType SessionID
        $configPath = "$([Environment]::GetFolderPath('ApplicationData'))\IvantiPS\config.json"
        $configPath | Should -Exist
    }
}
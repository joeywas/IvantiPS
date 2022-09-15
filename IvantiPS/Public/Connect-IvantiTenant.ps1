function Connect-IvantiTenant {
<#
    .SYNOPSIS
        Connect to an Ivanti Service Manager tenant

    .DESCRIPTION
        Connect to an Ivanti Service Manager tenant

    .PARAMETER Credential
        Credential object to use to authenticate with the ISM tenant

    .PARAMETER SessionID
        Existing session value to use instead of credentials

    .EXAMPLE
        Connect-IvantiTenant -Credential (Get-Credential)

    .NOTES
        https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Session-ID-Log-In.htm

    #>

    [CmdletBinding()]
    #[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseShouldProcessForStateChangingFunctions', '')]
    param(
        [Parameter(ParameterSetName="Credential")]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential,
        [Parameter(ParameterSetName="Session")]
        [string]$SessionID,
        [Parameter(ParameterSetName="APIKey")]
        [string]$APIKey
    )

    begin {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Function started"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Function started"

        $config = Get-IvantiPSConfig -ErrorAction Stop
        $tenant = $config.IvantiTenantID
        $LoginURL = "https://$($tenant)/api/rest/authentication/login"
    }

    process {
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] ParameterSetName: $($PsCmdlet.ParameterSetName)"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] PSBoundParameters: $($PSBoundParameters | Out-String)"

        if ($SessionID) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Existing SessionID passed in, using it"
            # If existing session id was passed in, use it
            #
            $result = $SessionID
        } elseif ($Credential) {
            # Create payload for call to login endpoint
            #
            $Payload = @{
                tenant = $tenant
                username = $Credential.username
                password = $Credential.GetNetworkCredential().password
                role = $config.DefaultRole
            }
            try {
                Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Invoking RestMethod on $LoginURL"
                $result = Invoke-RestMethod -Uri $LoginURL -Body $Payload -Method POST
            } catch {
                Write-Warning "[$($MyInvocation.MyCommand.Name)] Problem calling $LoginURL"
                $_
            }
        } elseif ($APIKey) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Existing APIKey passed in, using it"
            # If existing session id was passed in, use it
            #
            $result = $APIKey
        } else {
            Write-Warning "[$($MyInvocation.MyCommand.Name)] No Credentials, SessionID, or APIKey passed in. Exiting..."
            return
        }

        # The resulting session value from a valid call to the login url will be
        # saved in the module private data
        #
        if ($MyInvocation.MyCommand.Module.PrivateData) {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Adding session result to existing module PrivateData"
            $MyInvocation.MyCommand.Module.PrivateData.Session = $result
        }
        else {
            Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Creating module PrivateData"
            $MyInvocation.MyCommand.Module.PrivateData = @{
                'Session' = $result
            }
        }
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] SessionID: $result"
    }

    end {
        Write-Verbose "[$($MyInvocation.MyCommand.Name)] Complete"
        Write-DebugMessage "[$($MyInvocation.MyCommand.Name)] Complete"
    }
}

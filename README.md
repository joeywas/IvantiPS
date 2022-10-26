# IvantiPS
IvantiPS is a PowerShell module to interact with the Ivanti Service Manager (ISM) REST API.

## Description
The IvantiPS module is for doing data operations on business objects of the Ivanti Service Manager. It is built around the [Ivanti Service Manager Rest API](https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/RestAPI-Introduction.htm).

## Getting Started

### Dependencies

* Powershell 3.0 or greater

### Installing

Install IvantiPS from the PowerShell Gallery

```powershell
Install-Module IvantiPS -Scope CurrentUser
```

You may also clone this repo, build, then import the module

```powershell
Invoke-Build -Configuration Release -Verbose
Import-Module (Get-ChildItem .\Output\IvantiPS\*.psd1 -recurse) -force -verbose
```

### Configuring

After installing and importing, the module config must be set with a valid Ivanti tenant name. 

```powershell
Set-IvantiPSConfig -IvantiTenantID tenantname.ivanticloud.com -DefaultRole SelfService -AuthType SessionID
```

### Connecting with Basic Auth
Connect with set of credentials
```powershell
$Credential = Get-Credential
Connect-IvantiTenant -Credential $Credential
```

### Connecting with SessionID
If already authenticated to an Invanti tenant, the existing SessionID may be used. Open browser developer tools, find the cookie in Request headers, and the SessionID is the SID attribute in the cookie: `SID=tenantname.ivanticloud.com#GUPLABCNQ04GU8U248KQJ16TOVR4LASR#3;`

```powershell
$sessionID = 'tenantname.ivanticloud.com#GUPLABCNQ04GU8U248KQJ16TOVR4LASR#3'
Connect-IvantiTenant -SessionID $sessionID
```

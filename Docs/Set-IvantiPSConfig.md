---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Set-IvantiPSConfig

## SYNOPSIS
Set the URL, default Role, and Auth Type to use when connecting to Ivanti Service Manager

## SYNTAX

```
Set-IvantiPSConfig [-IvantiTenantID] <Uri> [-DefaultRole] <String> [-AuthType] <String> [<CommonParameters>]
```

## DESCRIPTION
Set the URL, default Role, and Auth Type to use when connecting to Ivanti Service Manager.
Saves the information to IvantiPS/config.json file in user profile

## EXAMPLES

### EXAMPLE 1
```
Set-IvantiPSConfig -IvantiTenantID tenantname.ivanticloud.com -DefaultRole SelfService -AuthType SessionID
```

## PARAMETERS

### -IvantiTenantID
Ivanti Tenant ID for IvantiCloud tenant.
example: tenantname.ivanticloud.com

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultRole
Default role to use to connect.
Example values: Admin, SelfService, SelfServiceViewer

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthType
Type of authentication to use to access ISM.
SessionID, APIKey, or OIDC

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Authentication_of_APIs.htm

## RELATED LINKS

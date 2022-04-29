---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Connect-IvantiTenant

## SYNOPSIS
Connect to an Ivanti Service Manager tenant

## SYNTAX

### Credential
```
Connect-IvantiTenant [-Credential <PSCredential>] [<CommonParameters>]
```

### Session
```
Connect-IvantiTenant [-SessionID <String>] [<CommonParameters>]
```

## DESCRIPTION
Connect to an Ivanti Service Manager tenant

## EXAMPLES

### EXAMPLE 1
```
Connect-IvantiTenant -Credential (Get-Credential)
```

## PARAMETERS

### -Credential
Credential object to use to authenticate with the ISM tenant

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionID
Existing session value to use instead of credentials

```yaml
Type: String
Parameter Sets: Session
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Session-ID-Log-In.htm

## RELATED LINKS

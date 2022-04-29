---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Get-IvantiCI

## SYNOPSIS
Get CI (assets) business objects from Ivanti.
Defaults to all.

## SYNTAX

```
Get-IvantiCI [[-RecID] <String>] [[-Name] <String>] [[-IPAddress] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get CI (assets) business objects from Ivanti.
Defaults to all.

## EXAMPLES

### EXAMPLE 1
```
Get-IvantiCI -Name wpdotsqll42
```

## PARAMETERS

### -RecID
Ivanti Record ID for a specific CI business object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
CI (Asset) Name to filter on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IPAddress
IP Address to filter on

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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
https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Get-Business-Object-by-Filter.htm

## RELATED LINKS

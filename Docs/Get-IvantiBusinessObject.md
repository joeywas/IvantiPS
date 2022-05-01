---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Get-IvantiBusinessObject

## SYNOPSIS
Get business objects from Ivanti.
Defaults to all.

## SYNTAX

```
Get-IvantiBusinessObject [-BusinessObject] <String> [[-RecID] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get business objects from Ivanti.
Defaults to all.

## EXAMPLES

### EXAMPLE 1
```
Get-IvantiBusinessObject -BusinessObject agency
```

### EXAMPLE 2
```
Get-IvantiBusinessObject -BusinessObject change
```

## PARAMETERS

### -BusinessObject
Ivanti Business Object to return

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecID
{{ Fill RecID Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

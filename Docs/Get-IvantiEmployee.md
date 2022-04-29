---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Get-IvantiEmployee

## SYNOPSIS
Get Employee business objects from Ivanti.
Defaults to all.

## SYNTAX

```
Get-IvantiEmployee [[-RecID] <String>] [[-Name] <String>] [[-Email] <String>] [-AllFields] [<CommonParameters>]
```

## DESCRIPTION
Get Employee business objects from Ivanti.
Defaults to all.

## EXAMPLES

### EXAMPLE 1
```
Get-IvantiEmployee -Email john.smith@domain.name
```

### EXAMPLE 2
```
Get-IvantiEmployee -Name 'John Smith'
```

### EXAMPLE 3
```
Get-IvantiEmployee -RecID DC218F83EC504222B148EF1344E15BCB -AllFields
```

## PARAMETERS

### -RecID
Ivanti Record ID for a specific Employee business object

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
Employee name, will filter against DisplayName property

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

### -Email
Employee email to filter on.

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

### -AllFields
Set this parameter if returning all fields is desired

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

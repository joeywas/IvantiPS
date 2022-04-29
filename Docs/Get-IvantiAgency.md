---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Get-IvantiAgency

## SYNOPSIS
Get Agency business objects from Ivanti.
Defaults to all.

## SYNTAX

```
Get-IvantiAgency [[-RecID] <String>] [[-Agency] <String>] [[-AgencyShortName] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get Agency business objects from Ivanti.
Defaults to all.

## EXAMPLES

### EXAMPLE 1
```
Get-IvantiAgency -AgencyShortName ACM
```

### EXAMPLE 2
```
Get-IvantiAgency -Agency 'Advanced Computer Machines'
```

### EXAMPLE 3
```
Get-IvantiAgency -RecID DC218F83EC504222B148EF1344E15BCB
```

## PARAMETERS

### -RecID
Ivanti Record ID for a specific Agency business object

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

### -Agency
Full agency name to filter on

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

### -AgencyShortName
Agency short name to filter on.
Usually an abbreviation

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

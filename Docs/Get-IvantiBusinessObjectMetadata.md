---
external help file: IvantiPS-help.xml
Module Name: IvantiPS
online version:
schema: 2.0.0
---

# Get-IvantiBusinessObjectMetadata

## SYNOPSIS
Get the metadata for an Ivanti Business Object

## SYNTAX

```
Get-IvantiBusinessObjectMetadata [-BusinessObject] <String> [-MetaDataType] <String> [<CommonParameters>]
```

## DESCRIPTION
Get the metadata for an Ivanti Business Object

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -BusinessObject
A business object to get meta data for.
Example value: agency

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

### -MetaDataType
The type of meta data to return.
May be Fields, Relationships, Actions, or SavedSearch

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Metadata.htm
https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Saved-Search-API.htm
https://help.ivanti.com/ht/help/en_US/ISM/2020/admin/Content/Configure/API/Quick-Actions-API.htm

## RELATED LINKS

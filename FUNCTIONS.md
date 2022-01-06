# PowerShellModuleTools

Text in this document is automatically created - don't change it manually

## Index

[Get-ModuleMarkup](#Get-ModuleMarkup)<br>
[Invoke-ModuleBuild](#Invoke-ModuleBuild)<br>
[New-ModuleBuildStructure](#New-ModuleBuildStructure)<br>

## Functions

<a name="Get-ModuleMarkup"></a>
### Get-ModuleMarkup

```

NAME
    Get-ModuleMarkup
    
SYNOPSIS
    Create Markup language content to automatically document PSModule
    
    
SYNTAX
    Get-ModuleMarkup [[-ModuleName] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Create Markup language content to automatically document PSModule
    

PARAMETERS
    -ModuleName <String>
        Name of module to document. Defaults to:
        Split-Path -Path (Get-Location) -Leaf
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-ModuleMarkup
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-ModuleMarkup | Out-File -FilePath .\FUNCTIONS.md -Encoding utf8
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-ModuleMarkup -examples".
    For more information, type: "get-help Get-ModuleMarkup -detailed".
    For technical information, type: "get-help Get-ModuleMarkup -full".

```

<a name="Invoke-ModuleBuild"></a>
### Invoke-ModuleBuild

```
NAME
    Invoke-ModuleBuild
    
SYNOPSIS
    Build module
    
    
SYNTAX
    Invoke-ModuleBuild [-Path <String>] [-JsonFile <String>] [-SourceRoot <String>] [-BuildRoot <String>] [-ManifestFile <String>] [-FunctionExportFile <String[]>] [-FunctionPrivateFile <String[]>] [-ClassFile <String[]>] [-AliasFile <String[]>] [-ExtraPSFile <String[]>] [-I
    ncludeFileDir <String>] [-Version <Version>] [-VersionAppendDate] [-NoTrim] [-BeforeZip <ScriptBlock[]>] [-AfterZip <ScriptBlock[]>] [-InstallModule] [-InstallModulePath <String>] [<CommonParameters>]
    
    Invoke-ModuleBuild [-Path <String>] -InputObject <PSObject> [-SourceRoot <String>] [-BuildRoot <String>] [-ManifestFile <String>] [-FunctionExportFile <String[]>] [-FunctionPrivateFile <String[]>] [-ClassFile <String[]>] [-AliasFile <String[]>] [-ExtraPSFile <String[]>] 
    [-IncludeFileDir <String>] [-Version <Version>] [-VersionAppendDate] [-NoTrim] [-BeforeZip <ScriptBlock[]>] [-AfterZip <ScriptBlock[]>] [-InstallModule] [-InstallModulePath <String>] [<CommonParameters>]
    
    Invoke-ModuleBuild [-Path <String>] -Module [-SourceRoot <String>] [-BuildRoot <String>] [-ManifestFile <String>] [-FunctionExportFile <String[]>] [-FunctionPrivateFile <String[]>] [-ClassFile <String[]>] [-AliasFile <String[]>] [-ExtraPSFile <String[]>] [-IncludeFileDir
     <String>] [-Version <Version>] [-VersionAppendDate] [-NoTrim] [-BeforeZip <ScriptBlock[]>] [-AfterZip <ScriptBlock[]>] [-TargetName <String>] [-Guid <Guid>] [-ManifestParameters <Hashtable>] [-InstallModule] [-InstallModulePath <String>] [<CommonParameters>]
    
    Invoke-ModuleBuild [-Path <String>] -ScriptFromTemplate [-SourceRoot <String>] [-BuildRoot <String>] [-ManifestFile <String>] [-FunctionExportFile <String[]>] [-FunctionPrivateFile <String[]>] [-ClassFile <String[]>] [-AliasFile <String[]>] [-ExtraPSFile <String[]>] [-In
    cludeFileDir <String>] [-Version <Version>] [-VersionAppendDate] [-NoTrim] [-BeforeZip <ScriptBlock[]>] [-AfterZip <ScriptBlock[]>] -TargetName <String> [-Guid <Guid>] -Template <String> [-InstallModule] [-InstallModulePath <String>] [<CommonParameters>]
    
    Invoke-ModuleBuild [-Path <String>] -ScriptFromFunction [-SourceRoot <String>] [-BuildRoot <String>] [-ManifestFile <String>] [-FunctionExportFile <String[]>] [-FunctionPrivateFile <String[]>] [-ClassFile <String[]>] [-AliasFile <String[]>] [-ExtraPSFile <String[]>] [-In
    cludeFileDir <String>] [-Version <Version>] [-VersionAppendDate] [-NoTrim] [-BeforeZip <ScriptBlock[]>] [-AfterZip <ScriptBlock[]>] -TargetName <String> [-Guid <Guid>] -Function <String> [-HelperFunction <String[]>] [-InstallModule] [-InstallModulePath <String>] [<Common
    Parameters>]
    
    
DESCRIPTION
    Build module - combine files to psm1, create psd1, zip it, ...
    

PARAMETERS
    -Path <String>
        Path
        
    -JsonFile <String>
        
    -InputObject <PSObject>
        
    -Module [<SwitchParameter>]
        
    -ScriptFromTemplate [<SwitchParameter>]
        
    -ScriptFromFunction [<SwitchParameter>]
        
    -SourceRoot <String>
        
    -BuildRoot <String>
        
    -ManifestFile <String>
        
    -FunctionExportFile <String[]>
        
    -FunctionPrivateFile <String[]>
        
    -ClassFile <String[]>
        
    -AliasFile <String[]>
        
    -ExtraPSFile <String[]>
        
    -IncludeFileDir <String>
        
    -Version <Version>
        
    -VersionAppendDate [<SwitchParameter>]
        
    -NoTrim [<SwitchParameter>]
        
    -BeforeZip <ScriptBlock[]>
        
    -AfterZip <ScriptBlock[]>
        
    -TargetName <String>
        
    -Guid <Guid>
        
    -ManifestParameters <Hashtable>
        
    -Template <String>
        
    -Function <String>
        
    -HelperFunction <String[]>
        
    -InstallModule [<SwitchParameter>]
        
    -InstallModulePath <String>
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Invoke-ModuleBuild
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Invoke-ModuleBuild -examples".
    For more information, type: "get-help Invoke-ModuleBuild -detailed".
    For technical information, type: "get-help Invoke-ModuleBuild -full".

```

<a name="New-ModuleBuildStructure"></a>
### New-ModuleBuildStructure

```
NAME
    New-ModuleBuildStructure
    
SYNOPSIS
    New module
    
    
SYNTAX
    New-ModuleBuildStructure [[-Path] <String>] [[-Directory] <String[]>] [[-JsonFile] <String>] [[-ManifestFile] <String>] [[-BuildFile] <String>] [[-TargetName] <String>] [-IncludeExamples] [[-ManifestParameters] <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
    
    
DESCRIPTION
    New module
    

PARAMETERS
    -Path <String>
        Path
        
    -Directory <String[]>
        
    -JsonFile <String>
        
    -ManifestFile <String>
        
    -BuildFile <String>
        
    -TargetName <String>
        
    -IncludeExamples [<SwitchParameter>]
        
    -ManifestParameters <Hashtable>
        
    -WhatIf [<SwitchParameter>]
        
    -Confirm [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>New-ModuleBuildStructure
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help New-ModuleBuildStructure -examples".
    For more information, type: "get-help New-ModuleBuildStructure -detailed".
    For technical information, type: "get-help New-ModuleBuildStructure -full".

```




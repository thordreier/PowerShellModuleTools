function New-ModuleBuildStructure
{
    <#
        .SYNOPSIS
            New module

        .DESCRIPTION
            New module

        .PARAMETER Path
            Path

        .EXAMPLE
            New-ModuleBuildStructure
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        [Parameter()]
        [String]
        $Path,

        [Parameter()]
        [String[]]
        $Directory = @('Alias', 'Class', 'FunctionExport', 'FunctionPrivate'),

        [Parameter()]
        [String]
        $JsonFile = 'Build.json',

        [Parameter()]
        [String]
        $ManifestFile = 'Manifest.psd1',

        [Parameter()]
        [String]
        $BuildFile = 'Build.ps1',

        [Parameter()]
        [String]
        $TargetName,

        [Parameter()]
        [Switch]
        $IncludeExamples,

        [Parameter()]
        [Hashtable]
        $ManifestParameters = @{}
    )

    Write-Verbose -Message "Begin (ParameterSetName: $($PSCmdlet.ParameterSetName))"
    $originalErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'

    # Other variables that (for new) doesn't come in as parameter
    $GitIgnoreFile = '.gitignore'

    # Check if file or directory exist and run scriptblock if it doesn't
    function CreatePath
    {
        param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [String]      $Path,
        [Parameter(Mandatory = $true)]                            [ScriptBlock] $ScriptBlock,
        [Parameter()][ValidateSet('File', 'Directory')]           [String]      $Type = 'File'
        )

        process
        {
            if (Test-Path -Path $Path)
            {
                if ($Type -eq 'File')
                {
                    $pathType = 'Leaf'
                    $warnMsg  = "File $Path already exist"
                    $errMsg   = "Cannot create file $Path, a directory already exist with that name"
                }
                elseif ($Type -eq 'Directory')
                {
                    $pathType = 'Container'
                    $warnMsg  = "Directory $Path already exist"
                    $errMsg   = "Cannot create directory $Path, a file already exist with that name"
                }

                if (Test-Path -Path $Path -PathType $pathType)
                {
                    Write-Warning -Message $warnMsg
                }
                else
                {
                    Write-Error -Message $errMsg
                }
            }
            else
            {
                . $ScriptBlock
            }
        }
    }

    # Write JSON to file - (only first level) will be sorted
    # This version only works on array of hashtables
    function WriteJson
    {
        param (
            [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [Hashtable[]] $Data,
            [Parameter(Mandatory = $true)]                            [String]      $Path
        )

        if ($input) {$Data = $input}

        $sorted = @(
            $Data | ForEach-Object -Process {
                $obj = New-Object -TypeName PSCustomObject
                $_.GetEnumerator() | Sort-Object -Property Key | ForEach-Object -Process {
                    $obj | Add-Member -MemberType NoteProperty -Name $_.Key -Value $_.Value
                }
                $obj
            }
        )
        ConvertTo-Json -Depth 10 -InputObject $sorted | Set-Content $Path
    }

    if ($PSCmdlet.ShouldProcess("Create module files in $Path"))
    {
        try
        {
            # Path defined as parameter
            if ($Path)
            {
                Write-Verbose -Message "cd $Path"
                $null = New-Item -Path $Path -ItemType Directory -ErrorAction SilentlyContinue
                Push-Location -Path $Path -StackName New-ModuleBuildStructure
            }

            # Resource sub directory in the module directory for this module
            $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath 'Resources'

            # TargetName end up in JSON - and in the end will be name of module
            if (-not $TargetName)
            {
                $TargetName = (Get-Location | Get-Item).Name
                Write-Verbose -Message "TargetName not defined, setting it to $TargetName based on working directory"
            }

            # Create directories
            $Directory | CreatePath -Type Directory -ScriptBlock {
                Write-Verbose "mkdir $Path"
                $null = New-Item -ItemType Directory -Path $Path
            }

            # Content of Build.json - if IncludeExamples is defined then more will be appended
            $jsonContent = @(
                @{
                    TargetName = $TargetName
                    Type       = 'Module'
                }
            )

            # Example stuff
            if ($IncludeExamples)
            {
                $exampleDirRequired = @('FunctionExport', 'FunctionPrivate')
                if ($exampleDirRequired.Where({$Directory.Contains($_)}).Count -eq $exampleDirRequired.Count)
                {
                    # Build.json
                    $exampleCmd = '$_.PSObject.Properties | select Name,@{N=''Value'';E={[String]$_.Value}},@{N=''Type'';E={$_.Value.GetType().Name}} | ft | Out-String'
                    $all = @{
                        SourceRoot          = '.'
                        BuildRoot           = 'Build'
                        ManifestFile        = 'Manifest.psd1'
                        FunctionExportFile  = @('FunctionExport\*.ps1')
                        FunctionPrivateFile = @('FunctionPrivate\*.ps1')
                        ClassFile           = @('Class\*.ps1')
                        AliasFile           = @('Alias\*.ps1')
                        ExtraPSFile         = @('Extra1\*.ps1', 'Extra2\*.ps1')
                        Version             = '1.2.3'
                        NoTrim              = $false
                        BeforeZip           = @($exampleCmd)
                        AfterZip            = @($exampleCmd)
                    }
                    $jsonContent += @(
                        $all + @{
                            TargetName         = 'ExampleModule'
                            Type               = 'Module'
                            Guid               = [Guid]::NewGuid()
                            ManifestParameters = @{Copyright = 'You shall not pass'}
                        }
                        $all + @{
                            TargetName         = 'ExampleScriptFromFunction'
                            Type               = 'ScriptFromFunction'
                            Guid               = [Guid]::NewGuid()
                            Function           = 'ExampleFunction'
                            HelperFunction     = 'HelperFunction'
                        }
                        $all + @{
                            TargetName         = 'ExampleScriptFromTemplate'
                            Type               = 'ScriptFromTemplate'
                            Guid               = [Guid]::NewGuid()
                            Template           = 'ExampleTemplate.ps1'
                        }
                    )

                    # Example functions
                    CreatePath -Path 'FunctionExport\ExampleFunction.ps1' -ScriptBlock {
                        'function ExampleFunction {param($P) "ExampleFunction: $P"; HelperFunction "$P plus more"}' | Set-Content -Path $Path
                    }
                    CreatePath -Path 'FunctionPrivate\HelperFunction.ps1' -ScriptBlock {
                        'function HelperFunction {param($P) "HelperFunction: $P"}' | Set-Content -Path $Path
                    }

                    # Example template
                    CreatePath -Path 'ExampleTemplate.ps1' -ScriptBlock {
                        @(
                            '{{function:ExampleFunction}}'
                            '{{function:HelperFunction}}'
                            'ExampleFunction "Calling ExampleFunction"'
                            'HelperFunction "Calling HelperFunction"'
                        ) -join "`r`n" | Set-Content -Path $Path
                    }
                }
                else
                {
                    Write-Warning -Message "-IncludeExamples is selected but -Directory does not include `"$($exampleDirRequired -join '" or "')`". Cannot create example functions."
                }
            }

            # Create Build.json
            CreatePath -Path $JsonFile -ScriptBlock {
                Write-Verbose -Message "Creating file $Path"
                $jsonContent | WriteJson -Path $Path
            }

            # Create Manifest.psd1
            CreatePath -Path $ManifestFile -ScriptBlock {
                Write-Verbose -Message "Creating file $Path"
                # Update-ModuleManifest produces nicer content than New-ModuleManifest (eg. UTF-8)
                $ManifestParameters['Path'] = $Path
                if (-not $ManifestParameters['RootModule']) {$ManifestParameters['RootModule'] = "$($TargetName).psm1"}
                New-ModuleManifest @ManifestParameters
                Update-ModuleManifest -Path $Path
                (Get-Content -Path $Path -Raw) -replace '^(#.*(\r?\n)+)*','' | Set-Content -Path $Path
            }

            # Copy Build.ps1
            CreatePath -Path $BuildFile -ScriptBlock {
                Write-Verbose -Message "Creating file $Path"
                $resourceBuild = Join-Path -Path $resourcesPath -ChildPath 'Build.ps1'
                Get-Content -Raw -Path $resourceBuild | Set-Content -Path $Path  # Not using Copy-Item to avoid NTFS properties copied
            }

            # Create .gitignore
            CreatePath -Path $GitIgnoreFile -ScriptBlock {
                "Build/*`r`n~*`r`n*~" | Set-Content -Path $Path
            }
        }
        catch
        {
            # If error was encountered inside this function then stop doing more
            # But still respect the ErrorAction that comes when calling this function
            # And also return the line number where the original error occured in verbose output
            Write-Verbose -Message "Detailed error info: $_`r`n$($_.InvocationInfo.PositionMessage)"
            Write-Error -ErrorAction $originalErrorActionPreference -Exception $_.Exception
        }
        finally
        {
            if ($Path)
            {
                Pop-Location -StackName New-ModuleBuildStructure -ErrorAction SilentlyContinue
            }        
        }
    }

    Write-Verbose -Message 'End'
}

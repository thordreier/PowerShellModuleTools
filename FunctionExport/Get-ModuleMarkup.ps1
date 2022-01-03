function Get-ModuleMarkup
{
    <#
        .SYNOPSIS
            Create Markup language content to automatically document PSModule

        .DESCRIPTION
            Create Markup language content to automatically document PSModule

        .PARAMETER ModuleName
            Name of module to document. Defaults to:
            Split-Path -Path (Get-Location) -Leaf

        .EXAMPLE
            Get-ModuleMarkup

        .EXAMPLE
            Get-ModuleMarkup | Out-File -FilePath .\FUNCTIONS.md -Encoding utf8
    #>

    [CmdletBinding()]
    param
    (
        [Parameter()]
        [string]
        $ModuleName
    )

    if (! $ModuleName)
    {
        $ModuleName = Split-Path -Path (Get-Location) -Leaf
        Write-Verbose -Message 'ModuleName not set, setting it to: $ModuleName'
    }

    '# {0}' -f $ModuleName
    ''
    'Text in this document is automatically created - don''t change it manually'
    ''
    '## Index'
    ''
    foreach ($function in (Get-Command -Module $ModuleName -CommandType Function))
    {
        '[{0}](#{1})<br>' -f $function.Name, $function.Name
    }
    ''
    '## Functions'
    ''

    foreach ($function in (Get-Command -Module $ModuleName -CommandType Function))
    {
        '<a name="{0}"></a>' -f $function.Name
        '### {0}' -f $function.Name
        ''
        '```'
        $function | Get-Help -Detailed
        '```'
        ''
    }
}

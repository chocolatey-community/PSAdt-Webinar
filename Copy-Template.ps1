<#
    .SYNOPSIS

    Copies a template from this repository to the Chocolatey templates directory. Creates directory if it doesn't exist.

    .PARAMETER Template

    The template(s) to copy

    .EXAMPLE
    
    Copy-Template.ps1 -Template psadtv4

    Copies the psadtv4 template

    .EXAMPLE
    Copy-Template -Template psadtv4,psadtv4-large

    Copies psadtv4 and psadtv4-large templates

#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [ArgumentCompleter({
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

            # Get the template directory path
            $templatePath = Join-Path -Path $PSScriptRoot -ChildPath 'template'

            # Ensure the directory exists
            if (Test-Path -Path $templatePath) {
                # Get directories and return completion results
                Get-ChildItem -Path $templatePath -Directory | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new(
                        $_.Name, $_.Name, 'ParameterValue', $_.FullName
                    )
                }
            }
        })]
    [String[]]
    $Template
)

begin {
    try {
        $null = Get-Command choco -ErrorAction Stop
    }
    catch {
        throw 'Chocolatey installation required for this script to work. See https://chocolatey.org/install (FOSS), or contact your system administrator!'
    }

    $Destination = (Join-Path $env:ChocolateyInstall -ChildPath 'templates')
    $templateDir = if (-not (Test-Path $Destination)){
        New-Item $Destination -ItemType Directory
    }
}

process {
    $Template | Foreach-Object {
        $SourcePath = Join-Path $PSScriptRoot\template -ChildPath $_
        Copy-Item $SourcePath -Destination $Destination -Recurse
    }
}
<#
    .SYNOPSIS
        Wraps an existing PSAppDeployToolkit v4 deployment in a Chocolatey package.

    .DESCRIPTION
        Copies a PSADT deployment into a templated Chocolatey package, with handling for various results.

    .EXAMPLE
        ConvertTo-ChocolateyPackage -Id 

    .EXAMPLE
        Get-ChildItem $PSADTPackagesFolder | ConvertTo-ChocolateyPackage

    .LINK
        https://github.com/chocolatey-community/PSADT-Webinar
#>
[CmdletBinding(DefaultParameterSetName = 'Default')]
param(
    # The ID to use for the Chocolatey package
    [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Large',Mandatory)]
    [Alias('BaseName','PackageId')]
    [String]$Id = $(Split-Path $PSADTPath -Leaf),

    # The path to the PSADT package you want to convert
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory, ParameterSetName = 'Default')]
    [ValidateScript({Test-Path $_})]
    [Alias('PSPath')]
    [String]$PSADTPath,

    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, Mandatory, ParameterSetName = 'Large')]
    [ValidateScript({Test-Path $_})]
    [Alias('PSAdtArchive')]
    [String]$LargeAppArchive,

    # The directory to create the Chocolatey package in
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Large')]
    [String]$OutputDirectory = $PSScriptRoot,

    # The name of a specific Chocolatey package template to use
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(Mandatory, ParameterSetName = 'Template')]
    [Parameter(ParameterSetName = 'Large')]
    [String]$Template,

    # Arguments to pass to the Chocolatey package template
    [Parameter(ParameterSetName = 'Default')]
    [Parameter(ParameterSetName = 'Template')]
    [Parameter(ParameterSetName = 'Large')]
    [Hashtable]$TemplateArgs,

    # If passed, compiles the package at the end of the script
    [switch]$CompilePackage
)

begin {
    $choco = try {
        (Get-Command choco -ErrorAction Stop).Source
    }
    catch {
        throw 'Chocolatey installation required for this script to work. See https://chocolatey.org/install (FOSS), or contact your system administrator!'
    }

    if ($Template) {
        $templateExists = Join-Path $env:ChocolateyInstall -ChildPath "templates\$Template"

        if (-not (Test-Path $templateExists)) {
            throw "Template $Template not found on this workstation, package creation cannot continue."
        }
    }
}

end {
    # Create the Chocolatey package
    $requiredArgs = @('new', $Id, "--output-directory='$OutputDirectory'")

    if($Template){
        $requiredArgs += "--template='$Template'"
        if ($TemplateArgs) {
            $TemplateArgs.GetEnumerator() | Foreach-Object {
                $requiredArgs += $("{0}='{1}'" -f $_.Key, $_.Value)
            }
        }
    
    }
    # Process any template values

    & $choco @requiredArgs

    # Get the tools folder
    $toolsDir = Join-Path $OutputDirectory -ChildPath "$Id\tools"

    # Copy PSADT application files to tools dir
    switch($PSCmdlet.ParameterSetName){
        'Large' {
            $requiredArgs += $("Location='{0}" -f $LargeAppArchive)
        }
        'Default' {
            Copy-Item $PSADTPath -Recurse -Destination $toolsDir
        }
    }

    # Compile the package if requested
    if ($CompilePackage) {
        $nuspec = (Get-ChildItem $OutputDirectory -Filter "$($Id).nuspec" -Recurse).FullName

        $packArgs = @('pack', $nuspec, "--output-directory='$OutputDirectory'")
        & $choco @packArgs
    }

}
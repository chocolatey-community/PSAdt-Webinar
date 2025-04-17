[CmdletBinding(DefaultParameterSetName = 'default')]
Param(

    [Parameter(ParameterSetName = 'default')]
    [String]
    $PackageId,

    [Parameter(Mandatory, ParameterSetName = 'default')]
    [String]
    $PSADTPath,

    [Parameter(ParameterSetName = 'default')]
    [String]
    $OutputDirectory = $PSScriptRoot,

    [Parameter(ParameterSetName = 'default')]
    [Parameter(Mandatory, ParameterSetName = 'Template')]
    [String]
    $Template,

    [Parameter(ParameterSetName = 'default')]
    [Parameter(ParameterSetName = 'Template')]
    [Hashtable]
    $TemplateArgs,

    [Parameter()]
    [Switch]
    $CompilePackage
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
    $requiredArgs = @('new', $PackageId, "--output-directory='$OutputDirectory'")

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
    $toolsDir = Join-Path $OutputDirectory -ChildPath "$PackageId\tools"

    # Copy PSADT application files to tools dir
    Copy-Item $PSADTPath -Recurse -Destination $toolsDir

    # Compile the package if requested
    if ($CompilePackage) {
        $nuspec = (Get-ChildItem $OutputDirectory -Filter *.nuspec -Recurse).FullName

        $packArgs = @('pack', $nuspec, "--output-directory='$OutputDirectory'")
        & $choco @packArgs
    }

}
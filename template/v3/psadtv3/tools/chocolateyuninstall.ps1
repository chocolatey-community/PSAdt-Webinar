$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$adtFolder = (Join-Path $toolsDir -ChildPath $env:ChocolateyPackageName)
$adtExe = Join-Path $adtFolder -ChildPath "Deploy-Application.exe"

<#
$packageArgs = @{
    ExetoRun = $adtExe
    statements = "-DeploymentType 'Uninstall' -DeployMode 'Silent'"
}

Start-ChocolateyProcessAsAdmin @packageArgs
#>

$uninstallArgs = @{
    PackageName = $env:ChocolateyPackageName
    FileType = 'EXE'
    SilentArgs = "-DeploymentType 'Uninstall' -DeployMode 'Silent'"
    validExitCodes = @(0)
    File = $adtExe
}

Uninstall-ChocolateyPackage @uninstallArgs
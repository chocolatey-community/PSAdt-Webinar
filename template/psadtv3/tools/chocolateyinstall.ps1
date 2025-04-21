$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$adtFolder = Join-Path $toolsDir -ChildPath $env:ChocolateyPackageName
$pp = Get-PackageParameters

# Determine our deployment mode
$validDeployModes = @('Interactive', 'Silent', 'NonInteractive')
$DeployMode = if (-not $pp['DeployMode']) {
    'Interactive'    
}
else {
    if ($pp['DeployMode'] -in $validDeployModes) {
        $pp['DeployMode']
    }
    else {
        throw "Invalid DeployMethod used. Valid options are $($validDeployModes -join ',')"
    }
}


# Determine path to deployment executable
$adtExe = Join-Path $adtFolder -ChildPath "Deploy-Application.exe"

# Define the known exit codes for PSAppDeployToolkit
$psAdtExitCodes = @{
    60001 = 'An error occurred in Deploy-Application.ps1. Check your script syntax use.'
    60002 = 'Error when running Execute-Process function.'
    60003 = 'Administrator privileges required for Execute-ProcessAsUser function.'
    60004 = 'Failure when loading .NET Winforms / WPF Assemblies.'
    60005 = 'Failure when displaying the Blocked Application dialog.'
    60006 = 'AllowSystemInteractionFallback option was not selected in the config XML file, so toolkit will not fall back to SYSTEM context with no interaction.'
    60007 = 'Deploy-Application.ps1 failed to dot source AppDeployToolkitMain.ps1 either because it could not be found or there was an error while it was being dot sourced.'
    60008 = 'The -UserName parameter in the Execute-ProcessAsUser function has a default value that is empty because no logged in users were detected when the toolkit was launched.'
    60009 = 'Deploy-Application.exe failed before PowerShell.exe process could be launched.'
    60010 = 'Deploy-Application.exe failed before PowerShell.exe process could be launched.'
    60011 = 'Deploy-Application.exe failed to execute the PowerShell.exe process.'
    60012 = 'A UI prompt timed out or the user opted to defer the installation.'
    60013 = 'If Execute-Process function captures an exit code out of range for int32 then return this custom exit code.'
}

$packageArgs = @{
    packagename    = $env:ChocolateyPackageName
    filetype       = 'exe'
    file           = $adtExe
    silentArgs     = "-DeploymentType 'Install' -DeployMode '$DeployMode'"
    validExitCodes = @(0)
    softwareName   = '[[Title]]*'
}

Install-ChocolateyInstallPackage @packageArgs

if ($LASTEXITCODE -ne 0) {
    if ($psAdtExitCodes.ContainsKey($LASTEXITCODE)) {
        throw $psAdtExitCodes[$LASTEXITCODE]
    }
    else {
        throw "Unknown error occurred. See $env:ChocolateyInstall\logs\chocolatey.log for details."
    }
}

#If the user doesn't defer, we need to prevent shimgen from creating a bunch of shims
Get-ChildItem $toolsDir -Recurse -Include '*.exe', '*.msi', '*.bat' | ForEach-Object { $null = New-Item "$($_.FullName).ignore" -ItemType File }
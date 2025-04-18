# Unwrapping Chocolatey: PSAppDeployToolkit

In our April 2025 webinar Senior Solutions Engineer James Ruskin and Customer Success Manager Stephen Valdinger take you step-by-step through leveraging Chocolatey to deploy your PSAppDeployToolkit applications.

Learn how to streamline your transition to Chocolatey without having to redo any of the applications currently being managed via tools like SCCM.

## Available Templates

Find information about the individual templates including usage and setup instructions at the links below.

- [psadtv4](template-psadtv4.md)
- [psadtv4-large](template-psadtv4-large.md)

## Adding Templates to Chocolatey

You can add all of the templates included in this repository by using the included `Copy-Template.ps1` script

```powershell
# Copy psadtv4 template to $env:ChocolateyInstall\templates
. .\Copy-Template.ps1 -Template psadtv4
```

```powershell
# Copy psadtv4 and psadtv4-large templates to $env:ChocolateyInstall\templates
. .\Copy-Template.ps1 -Template psadtv4,psadtv4-large
```

## Using the new Chocolatey Package

### Installation

By default the Chocolatey package will use PSADT's `Interactive` DeployMode to allow for the use of deferments by the end user.
This will fail the package installation up to the deferrment allowance of the psadt application.

```powershell
choco install <packageid> -y
```

You may override this behavior with the use of package parameters

```powershell
# Set DeployMode to Silent, so no deferral by the end user can occur and the application is installed.
choco install <packageid> -y --package-parameters="/DeployMode='Silent'"
```

### Uninstallation

In _most_ cases, Chocolatey's AutoUninstaller feature will handle the software removal for you while uninstalling the Chocolatey package.

If you would like to use the PSAdt app's uninstallation methods, or the package does not remove the software correctly, copy the included `chocolateyUninstall.ps1` file from this repository to the tools directory of your new Chocolatey package, and run `choco pack` against the package nuspec to include the script in the compiled Chocolatey package.

With the script include, Chocolatey will attempt to use the PSAdt app's uninstallation instruction set.

## Additional Resources

- [Back To Basics: Chocolatey Templates (Youtube)](https://www.youtube.com/watch?v=J43T3QArbNE)
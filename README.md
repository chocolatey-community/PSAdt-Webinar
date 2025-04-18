# Unwrapping Chocolatey: PSAppDeployToolkit

In our April 2025 webinar Senior Solutions Engineer James Ruskin and Customer Success Manager Stephen Valdinger take you step-by-step through leveraging Chocolatey to deploy your PSAppDeployToolkit applications.

Learn how to streamline your transition to Chocolatey without having to redo any of the applications currently being managed via tools like SCCM.

## Available Templates

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

## ConvertTo-ChocolateyPackage.ps1

This helper script works in tandem with the PSADT template allowing you to quickly convert a PSAdt application into a Chocolatey package without having to copy files manually, or edit any Chocolatey packaging scripts. Simply pass the appropriate parameters, and let Chocolatey do all the work!

## Using the new Chocolatey Package

By default the Chocolatey package will use PSADT's `Interactive` DeployMode to allow for the use of deferments by the end user. You may override this behavior with the use of package parameters

```powershell
# Set DeployMode to Silent, so no deferral by the end user can occur
choco install <packageid> -y --package-parameters="/DeployMode='Silent'"
```

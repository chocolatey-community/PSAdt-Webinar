# PSADTv3 Template

The `psadtv3` template provides the code required to package a PSAppDeployToolkit v3 application as a Chocolatey package.

_⚠️ **DISCLAIMER**_

The v3 template provided in this repository is made available as a best-effort as we were unable to produce a _native_ PSADT v3 application for testing, and the v3 backwards compatible
template available in the latest release of PSAdt is incomplete.

## PSADTv3 Template Values

The v3 templates need some information from the user when building a package from the template. Required information is:

- PackageVersion: The version for the Chocolatey package, recommended to be the version number from the installer.
- Title: The title for the package. This is a slightly more descriptive name for the package in addition to the package id.
- Organization: Your organization name.

### Usage

#### Directly via Chocolatey

You can use this template directly via Chocolatey, however you will need to copy the PSAppDeployToolkit application folder and its contents to the Chocolatey package's `tools` directory prior to packing and publishing the package to your repository for use.

```powershell
choco new <packageid> --template='psadtv3' --version='<package version>' Title='<Software title>' Organization='<Your org>'
```

#### ConvertTo-ChocolateyPackage.ps1

You can use the `ConvertTo-ChocolateyPackage.ps1` script in this repository to convert your PSADT app to a Chocolatey package.

_Notes:_

- The package id is automatically set the the folder name of the PSAppDeployToolkit application. Use `-Id` to override.
- The output directory of the Chocolatey package defaults to the current working directory. Use `-OutputDirectory to override.
- Use `-CompilePackage` to create the package nupkg file automatically. Otherwise, you will need to run `choco pack` against the package nuspec once you are ready.

```powershell
$templateArguments = @{
    PackageVersion = '<package version>'
    Title = '<software title>'
    Organization = '<organization name>'
}

. .\ConvertTo-ChocolateyPackage -PSADTPath '<PSADT App path>' -Template psadtv3 -TemplateArgs $templateArguments
```

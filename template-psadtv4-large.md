# PSADTv4-large Template

The `psadtv4-large` template provides the code required to package a PSAppDeployToolkit v4 application as a Chocolatey package where the PSAppDeployToolkit application is larger than 2 GB in size.

In order to use this template you will need to zip up your PSADT app and place it somewhere accessible during the installation of the Chocolatey package. This can be either a UNC file share or a URL.

## PSADTv4-Large Template Values

The v4 templates need some information from the user when building a package from the template. Required information is:

- PackageVersion: The version for the Chocolatey package, recommended to be the version number from the installer.
- Title: The title for the package. This is a slightly more descriptive name for the package in addition to the package id.
- Organization: Your organization name.
- Location: The path to the PSAddt app archive. Can be a UNC share path or url. Only used when using template with Chocolatey directly.

### Usage

#### Directly via Chocolatey

You can use this template directly via Chocolatey, however you will need to copy the PSAppDeployToolkit application folder and its contents to the Chocolatey package's `tools` directory prior to packing and publishing the package to your repository for use.

```powershell
choco new <package id> --template='psadtv4-large' --version='<package version>' Title='<Software title>' Organization='<Your org>' Location='<unc path or url>'
```

#### ConvertTo-ChocolateyPackage.ps1

You can use the `ConvertTo-ChocolateyPackage.ps1` script in this repository to convert your PSADT app to a Chocolatey package.

_Notes:_

- The output directory of the Chocolatey package defaults to the current working directory. Use `-OutputDirectory to override.
- Use `-CompilePackage` to create the package nupkg file automatically. Otherwise, you will need to run `choco pack` against the package nuspec once you are ready.

```powershell
$templateArguments = @{
    PackageVersion = '<package version>'
    Title = '<software title>'
    Organization = '<organization name>'
}

. .\ConvertTo-ChocolateyPackage -Id '<package id>' -PSAdtArchive '<PSADT App zip file>' -Template psadtv4-large -TemplateArgs $templateArguments
```

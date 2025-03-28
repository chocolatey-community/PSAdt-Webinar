# Unwrapping Chocolatey: PSAppDeployToolkit

In our April 2025 webinar Senior Solutions Engineer James Ruskin and Customer Success Manager Stephen Valdinger take you step-by-step through leveraging Chocolatey to deploy your PSAppDeployToolkit applications.

Learn how to streamline your transition to Chocolatey without having to redo any of the applications currently being managed via tools like SCCM.

## PSADT Template

The Template folder contains a PSADT template you can use with the `choco new` command to quickly scaffold a new Chocolatey package based on a PSAdt application.

## ConvertTo-ChocolateyPackage.ps1

This helper script works in tandem with the PSADT template allowing you to quickly convert a PSAdt application into a Chocolatey package without having to copy files manually, or edit any Chocolatey packaging scripts. Simply pass the appropriate parameters, and let Chocolatey do all the work!
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ArgumentCompleter({
        param($1, $2, $WordToComplete, $4, $BoundParams)
        Get-ChildItem HKLM:\SOFTWARE\PSAppDeployToolkit\DeferHistory\ | ForEach-Object {
            $Id, $Version, $Language, $Count = (Split-Path $_.Name -Leaf).Split('_')
            @{Id = $Id; Version = $Version; Language = $Language; Count = $Count}
        } | Where-Object Id -like "$WordToComplete*" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_.Id,
                $_.Id,
                "ParameterValue",
                "$($_.Id) $($_.Version) ($(
                    Get-ItemPropertyValue HKLM:\SOFTWARE\PSAppDeployToolkit\DeferHistory\$($_.Id)_$($_.Version)_$($_.Language)_$($_.Count) -Name DeferTimesRemaining
                ) remaining)"
            )
        }
    })]
    [string]$Id,

    [ArgumentCompleter({
        param($1, $2, $WordToComplete, $4, $BoundParams)
        Get-ChildItem HKLM:\SOFTWARE\PSAppDeployToolkit\DeferHistory\ | ForEach-Object {
            $Id, $Version, $Language, $Count = (Split-Path $_.Name -Leaf).Split('_')
            @{Id = $Id; Version = $Version; Language = $Language; Count = $Count}
        } | Where-Object Id -like $BoundParams.Id | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_.Version,
                $_.Version,
                "ParameterValue",
                "$($_.Id) $($_.Version) ($(
                    Get-ItemPropertyValue HKLM:\SOFTWARE\PSAppDeployToolkit\DeferHistory\$($_.Id)_$($_.Version)_$($_.Language)_$($_.Count) -Name DeferTimesRemaining
                ) remaining)"
            )
        }
    })]
    [string]$Version = "*",

    [int]$Remaining
)

$RegistryPath = "HKLM:\SOFTWARE\PSAppDeployToolkit\DeferHistory\$Id"
$RegistryPath += if ($Version) {
    "_$Version_*"
} else {
    "_*"
}

if (($ResolvedPath = Resolve-Path $RegistryPath).Count -gt 1) {
    Write-Error "More than one version of $Id was found. Please specify -Version." -ErrorAction Stop
}

if ($Remaining) {
    if ($PSCmdlet.ShouldProcess("$($ResolvedPath.Path)[DeferTimesRemaining]", "Setting to '$Remaining'")) {
        Set-ItemProperty -Path $ResolvedPath.Path -Name DeferTimesRemaining -Value $Remaining
    }
} else {
    if ($PSCmdlet.ShouldProcess($ResolvedPath.Path, "Removing")) {
        Remove-Item $ResolvedPath.Path
    }
}
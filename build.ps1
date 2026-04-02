#Requires -Version 5.1
<#
  Build Notepad2e with MSBuild from the latest Visual Studio installation.
  Requires BOOST_ROOT (Boost root containing the `boost` folder) for Release/Debug.
  Usage:
    .\build.ps1
    .\build.ps1 -Configuration Debug -Platform x86
#>
param(
    [ValidateSet('Debug', 'Release', 'Debug ICU', 'Release ICU', 'Debug LPeg', 'Release LPeg', 'Release ICU LPeg')]
    [string] $Configuration = 'Release',

    [ValidateSet('x64', 'x86')]
    [string] $Platform = 'x64'
)

$ErrorActionPreference = 'Stop'

$root = $PSScriptRoot
$sln = Join-Path $root 'Notepad2e.sln'
if (-not (Test-Path -LiteralPath $sln)) {
    Write-Error "Solution not found: $sln"
    exit 1
}

$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (-not (Test-Path -LiteralPath $vswhere)) {
    Write-Error "vswhere.exe not found. Install Visual Studio with MSBuild."
    exit 1
}

$msbuild = & $vswhere -latest -requires Microsoft.Component.MSBuild -find 'MSBuild\**\Bin\MSBuild.exe' |
    Select-Object -First 1
if (-not $msbuild -or -not (Test-Path -LiteralPath $msbuild)) {
    Write-Error "MSBuild.exe not found via vswhere."
    exit 1
}

if (-not $env:BOOST_ROOT) {
    Write-Warning 'BOOST_ROOT is not set. Set it to your Boost root (folder that contains the `boost` subdirectory), then rebuild.'
}

Write-Host "MSBuild: $msbuild"
Write-Host "Configuration=$Configuration Platform=$Platform"
& $msbuild $sln /m /v:minimal /nologo /restore `
    /p:Configuration=$Configuration `
    /p:Platform=$Platform

exit $LASTEXITCODE

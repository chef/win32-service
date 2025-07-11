param(
    [Parameter(Mandatory = $true)]
    [string]$RubyVersion
)

$ErrorActionPreference = "Stop"

Write-Output "--- Pruning the PATH to remove any existing 'C:\tools' segments"
$pathSegments = $env:Path -split ';'
# Filter out segments that start with "C:\tools"
$filteredSegments = $pathSegments | Where-Object { $_ -notlike "C:\tools*" }
# Join the remaining segments back together
$env:Path = $filteredSegments -join ';'

Write-Output "--- Here is the updated PATH: $env:Path"

Write-Output "--- Is Ruby already installed? Trying Get-Command ruby"
$rubyInstalled = Get-Command ruby -ErrorAction SilentlyContinue
if ($rubyInstalled) {
    Write-Output "Ruby is already installed at $($rubyInstalled.Source)"
} else {
    Write-Output "Ruby is not installed."
}

Write-Output "--- Is Ruby already installed? Trying Get-Childitem"
$rubies = Get-ChildItem -Path "C:\" -Filter "ruby.exe" -Recurse -ErrorAction SilentlyContinue
if ($rubies) {
    Write-Output "Found ($rubies.Count) Ruby installations."
    Write-Output "They are located at:"
    foreach ($ruby in $rubies) {
        Write-Output $ruby.FullName
        Write-Output "--- What version is this Ruby? Trying ruby --version"
        & $ruby.FullName "--version"
    }
} else {
    Write-Output "No Ruby installations found."
}

Write-Output "--- Now deleting all the Ruby installations found"
foreach ($ruby in $rubies) {
    Remove-Item -Path $ruby.DirectoryName -Recurse -Force
    Write-Output "Deleted Ruby installation at $($ruby.FullName)"
}

Write-Output "--- Removing any existing Ruby installations from C:\ruby"
if (Test-Path -Path "C:\ruby") {
    Write-Output "--- Removing C:\ruby directory"
    Remove-Item -Path "C:\ruby" -Recurse -Force
} else {
    Write-Output "--- C:\ruby directory does not exist, skipping removal"
}

Write-Output "--- Removing any existing Ruby installations that are installed with Chocolatey"
choco uninstall ruby --version 3.1.6.1 -y -f
choco uninstall ruby --version 3.4.4.2 -y -f

Write-Output "--- Installing Ruby $RubyVersion and MSYS2 using Chocolatey"
choco install ruby --version $RubyVersion --force -y
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv
if (-not $?) { throw "Failed to install Ruby $RubyVersion." }

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User") 

Write-Output "--- Installing MSYS2 for Ruby $RubyVersion"

Write-Output "--- I am on Drive: $((Get-Location).Drive.Root)"

Write-Output "--- Searching for existing MSYS2 installations"
$devkits = Get-ChildItem $((Get-Location).Drive.Root) "Msys64" -Directory -Recurse -ErrorAction SilentlyContinue
foreach ($devkit in $devkits) {
    Write-Output "Found MSYS2 installation at: $($devkit.FullName)"
}

Write-Output "--- Removing existing MSYS2 installations, if they exist"
foreach ($devkit in $devkits) {
    Remove-Item -Path $devkit.DirectoryName -Recurse -Force
    Write-Output "Deleted MSYS2 installation at $($devkit.FullName)"
}

Write-Output "--- Updating PATH using refreshenv"
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
refreshenv
Write-Output "--- Installing MSYS2 and configuring Ruby DevKit"
choco install msys2 --params "/NoUpdate" --force -y
Update-SessionEnvironment
ridk install 2 3

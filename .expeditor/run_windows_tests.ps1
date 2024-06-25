param (string $Ruby)

Set-ExecutionPolicy Bypass
$ErrorActionPreference='Stop'
$ProgressPreference='SilentlyContinue'
$env:chocolateyVersion="1.4.0"

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
choco feature enable -n=allowGlobalConfirmation
choco config set cacheLocation C:\chococache
choco upgrade chocolatey
choco install git
Remove-Item -Recurse -Force c:\chococache

if($Ruby -eq "3.0")
{
  $env:RUBY_URL="https://github.com/oneclick/rubyinstaller3/releases/download/RubyInstaller-3.0.6-1/rubyinstaller-3.0.6-1-x64.exe"
  $env:RUBY_FILE="rubyinstaller-3.0.6-1-x64.exe"
  $env:RUBY_DIR="c:/ruby30"
}
if($Ruby -eq "3.1")
{
  $env:RUBY_URL="https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.4-1/rubyinstaller-3.1.4-1-x64.exe"
  $env:RUBY_FILE="rubyinstaller-3.1.4-1-x64.exe"
  $env:RUBY_DIR="c:/ruby31"
}

# Install Ruby + Devkit
Write-Output 'Downloading Ruby + DevKit'; \
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
  (New-Object System.Net.WebClient).DownloadFile("$env:RUBY_URL", "c:/$env:RUBY_FILE")

Write-Output 'Installing Ruby + DevKit'
Start-Process "c:/$env:RUBY_FILE" -ArgumentList "/allusers /verysilent /dir=$env:RUBY_DIR" -Wait

Write-Output 'Cleaning up installation'
Remove-Item "c:/$env:RUBY_FILE" -Force

# This will run ruby test on windows platform

Write-Output "--- Bundle install"

bundle config --local path vendor/bundle
If ($lastexitcode -ne 0) { Exit $lastexitcode }

bundle install --jobs=7 --retry=3
If ($lastexitcode -ne 0) { Exit $lastexitcode }

Write-Output "--- Bundle Execute"

bundle exec rake --trace
If ($lastexitcode -ne 0) { Exit $lastexitcode }

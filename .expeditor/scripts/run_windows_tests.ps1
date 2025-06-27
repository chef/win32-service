# Stop script execution when a non-terminating error occurs
$ErrorActionPreference = "Stop"

$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Output "--- We are in the Run Windows Tests script"
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

Write-Output "--- Here is my path: $env:PATH"

Write-Output "--- Installed Ruby version"
ruby --version

Write-Output "--- Bundle install"

bundle config --local path vendor/bundle
bundle install --jobs=7 --retry=3
if (-not $?) { throw "bundle install failed" }

Write-Output "--- Running Cookstyle"
gem install cookstyle
cookstyle --chefstyle -c .rubocop.yml
if (-not $?) { throw "Cookstyle failed." }

Write-Output "--- Bundle Execute"

bundle exec rake
if (-not $?) { throw "Rake task failed." }
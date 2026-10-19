# Script para subir el visor a GitHub Pages
# Ejecutar desde PowerShell como administrador o doble click

$visorPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$envPath = "C:\Users\raul_\OneDrive\Desktop\Proyectos de Trading\SMA Bot\.env"

# Leer variables del .env
Get-Content $envPath | ForEach-Object {
    if ($_ -match "^([^#=]+)=(.+)$") {
        [System.Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim())
    }
}

$ghPat = [System.Environment]::GetEnvironmentVariable("GITHUB_PAT")
$ghRepo = [System.Environment]::GetEnvironmentVariable("GITHUB_REPO_URL")
$repoUrl = $ghRepo -replace "https://", "https://$ghPat@"

Set-Location $visorPath

if (-not (Test-Path ".git")) {
    git init
    git config user.email "raulnunez067@gmail.com"
    git config user.name "RaulN03012003"
}

$remotes = git remote 2>&1
if ($remotes -match "origin") {
    git remote set-url origin $repoUrl
} else {
    git remote add origin $repoUrl
}

git add index.html data.js
git commit -m "Visor SMABot - actualizacion pipeline"
git branch -M main
git push -u origin main --force

Write-Host ""
Write-Host "Subida completada. GitHub Pages disponible en:"
Write-Host "https://rauln03012003.github.io/smabot-visor/"

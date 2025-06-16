# PowerShell script to apply template variables to folder and file names, and file contents
# Usage: .\Apply-DomainTemplate.ps1 -DomainName "YourDomainName" -DomainShortName "yourshortname"

param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    [Parameter(Mandatory=$true)]
    [string]$DomainShortName,
    [Parameter(Mandatory=$true)]
    [string]$ApiPort,
    [Parameter(Mandatory=$true)]
    [string]$MsgPort 
)

function Replace-InFile {
    param(
        [string]$Path,
        [string]$Old,
        [string]$New
    )
    (Get-Content $Path) -replace $Old, $New | Set-Content $Path
}

# 1. Replace template variables in all files, EXCEPT this script itself
$scriptName = $MyInvocation.MyCommand.Name
$files = Get-ChildItem -Path . -Recurse -File -Include *.cs,*.csproj,*.json,*.yml,*.sln,*.md,*.xml | Where-Object { $_.Name -ne $scriptName }
foreach ($file in $files) {
    Replace-InFile -Path $file.FullName -Old "{{DomainName}}" -New $DomainName
    Replace-InFile -Path $file.FullName -Old "{{DomainShortName}}" -New $DomainShortName
    Replace-InFile -Path $file.FullName -Old "{{api_port}}" -New $ApiPort
    Replace-InFile -Path $file.FullName -Old "{{msg_port}}" -New $MsgPort
}


# 3. Rename solution and project files if needed
$solutionFile = Get-ChildItem -Path . -Filter "*.sln" | Select-Object -First 1
if ($solutionFile) {
    $newSolutionName = $solutionFile.Name -replace "{{DomainName}}", $DomainName
    if ($solutionFile.Name -ne $newSolutionName) {
        Rename-Item -Path $solutionFile.FullName -NewName $newSolutionName
    }
}

# 4. Rename project files inside src
$projFiles = Get-ChildItem -Path ./src -Recurse -Filter "*.csproj"
foreach ($proj in $projFiles) {
    $newProjName = $proj.Name -replace "{{DomainName}}", $DomainName
    if ($proj.Name -ne $newProjName) {
        Rename-Item -Path $proj.FullName -NewName $newProjName
    }
}

# 5. Create appsettings.Development.json in each project folder if it doesn't exist, using appsettings.json as a template
$projectFolders = @(
    ".\src\Api",
    ".\src\App",
    ".\src\Message"
)
foreach ($folder in $projectFolders) {
    $appSettingsPath = Join-Path $folder "appsettings.json"
    $devSettingsPath = Join-Path $folder "appsettings.Development.json"
    if ((Test-Path $appSettingsPath) -and -not (Test-Path $devSettingsPath)) {
        Get-Content $appSettingsPath | Set-Content $devSettingsPath -Encoding UTF8
        Write-Host "Created $devSettingsPath from $appSettingsPath"
    }
}

Write-Host "Domain template applied. Folders, files, and contents updated."
Write-Host "" -ForegroundColor Yellow
Write-Host "*** IMPORTANT: You MUST manually set your secrets and environment-specific values in the appsettings.json and appsettings.Development.json files for each service! ***" -ForegroundColor Red
Write-Host "If you skip this step, your application will not run correctly." -ForegroundColor Red

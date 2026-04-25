$toolsDir = Join-Path $PSScriptRoot "Tools"
$gameDir = Join-Path $PSScriptRoot "Game"

if (!(Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir | Out-Null
}

if (!(Test-Path $gameDir)) {
    New-Item -ItemType Directory -Path $gameDir | Out-Null
}

if (Get-Command python -ErrorAction SilentlyContinue) {
    if (python --version 2>$null -match "Python 3\.(1[0-9]|[2-9][0-9])") {
        Write-Host "Python 3.10+ already installed" -ForegroundColor Green
    } else {
        Write-Error "Incompatible Python version found. Please install Python 3.10+."
    }
} else {
    Write-Error "Python not found. Please install Python 3.10+."
}

if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    if (dotnet --version 2>$null -like "10.*") {
        Write-Host ".NET 10 already installed" -ForegroundColor Green
    } else {
        Write-Error "Incompatible .NET version found. Please install .NET 10 SDK."
    }
} else {
    Write-Error ".NET not found. Please install .NET 10 SDK."
}

if (Test-Path (Join-Path $toolsDir "UndertaleModCli/UndertaleModCli.exe")) {
    Write-Host "UndertaleModCli already installed" -ForegroundColor Green 
} else {
    Write-Host "downloading UndertaleModCli" -ForegroundColor Cyan
    $zipPath = Join-Path $PSScriptRoot "umt.zip"
    try {
        Invoke-WebRequest -Uri "https://github.com/UnderminersTeam/UndertaleModTool/releases/download/0.8.4.1/UTMT_CLI_v0.8.4.1-Windows.zip" -OutFile $zipPath
        Expand-Archive $zipPath -DestinationPath (Join-Path $toolsDir "UndertaleModCli")
        Remove-Item $zipPath
        Write-Host "UndertaleModCli installed" -ForegroundColor Green 
    } catch {
        Write-Error "UndertaleModCli download failed."
    }
}

$xdeltaPath = Join-Path $toolsDir "xdelta3/xdelta3.exe"
if (Test-Path $xdeltaPath) {
    Write-Host "xdelta3 already installed" -ForegroundColor Green
} else {
    Write-Host "downloading xdelta3" -ForegroundColor Cyan
    $zipPath = Join-Path $PSScriptRoot "xdelta.zip"
    $destDir = Join-Path $toolsDir "xdelta3"
    try {
        Invoke-WebRequest -Uri "https://github.com/jmacd/xdelta-gpl/releases/download/v3.0.11/xdelta3-3.0.11-x86_64.exe.zip" -OutFile $zipPath
        Expand-Archive $zipPath -DestinationPath $destDir
        Move-Item (Join-Path $destDir "xdelta3-3.0.11-x86_64.exe") $xdeltaPath -Force
        Remove-Item $zipPath
        Write-Host "xdelta3 installed" -ForegroundColor Green
    } catch {
        Write-Error "xdelta3 download failed."
    }
}

$ddPath = Join-Path $toolsDir "DepotDownloader/DepotDownloader.exe"
if (Test-Path $ddPath) {
    Write-Host "DepotDownloader already installed" -ForegroundColor Green
} else {
    Write-Host "downloading DepotDownloader" -ForegroundColor Cyan
    $zipPath = Join-Path $PSScriptRoot "depot.zip"
    try {
        Invoke-WebRequest -Uri "https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-windows-x64.zip" -OutFile $zipPath
        Expand-Archive $zipPath -DestinationPath (Join-Path $toolsDir "DepotDownloader")
        Remove-Item $zipPath
        Write-Host "DepotDownloader installed" -ForegroundColor Green
    } catch {
        Write-Error "DepotDownloader download failed."
    }
}

$needsOld = !(Test-Path (Join-Path $gameDir "1.42/data.win"))
$needsNew = !(Test-Path (Join-Path $gameDir "2.12/data.win"))
if ($needsOld -or $needsNew) {
    $steamUser = Read-Host "Enter your Steam username to download game files"
    $targets = @()
    if ($needsOld) {
        $targets += [PSCustomObject]@{
            Ver = "1.42";
            Manifest = "8825902836070948945"
        }
    }

    if ($needsNew) {
        $targets += [PSCustomObject]@{
            Ver = "2.12";
            Manifest = "7209330756320585568"
        }
    }

    foreach ($target in $targets) {
        Write-Host "downloading $($target.Ver) game files" -ForegroundColor Cyan
        $outDir = Join-Path $GameDir $target.Ver
        & $ddPath -app 1115050 -depot 1115051 -manifest $target.Manifest -beta sandbox -dir $outDir -username $steamUser -remember-password
        "1115050" | Out-File -FilePath (Join-Path $outDir "steam_appid.txt") -Encoding ascii -NoNewline
        Remove-Item -Path (Join-Path $outDir ".DepotDownloader") -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "game files already installed" -ForegroundColor Green
}

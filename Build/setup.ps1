if (!(Test-Path "./Tools")) {
    New-Item -ItemType Directory -Path "./Tools"
}

if (Get-Command python -ErrorAction SilentlyContinue) {
    $pyVer = python --version 2>$null
    if ($pyVer -match "Python 3\.(1[0-9]|[2-9][0-9])") {
        Write-Host "Python 3.10+ already installed" -ForegroundColor Green
    } else {
        Write-Error "Incompatible Python version found. Please install Python 3.10+."
    }
} else {
    Write-Error "Python not found. Please install Python 3.10+."
}

if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    $dotnetVer = dotnet --version 2>$null
    if ($dotnetVer -like "10.*") {
        Write-Host ".NET 10 already installed" -ForegroundColor Green
    } else {
        Write-Error "Incompatible .NET version found. Please install .NET 10 SDK."
    }
} else {
    Write-Error ".NET not found. Please install .NET 10 SDK."
}

if (Test-Path "./Tools/UndertaleModCli.exe") {
    Write-Host "UndertaleModCli already installed" -ForegroundColor Green 
} else {
    Write-Host "downloading UndertaleModCli" -ForegroundColor Cyan
    $umtUrl = "https://github.com/UnderminersTeam/UndertaleModTool/releases/download/0.8.4.1/UTMT_CLI_v0.8.4.1-Windows.zip"
    try {
        Invoke-WebRequest -Uri $umtUrl -OutFile "umt.zip"
        Expand-Archive "umt.zip" -DestinationPath "./Tools"
        Remove-Item "umt.zip"
        Write-Host "UndertaleModCli installed" -ForegroundColor Green 
    } catch {
        Write-Error "UndertaleModCli download failed. Please manually place UndertaleModCli.exe in the ./Tools folder."
    }
}

if (Test-Path "./Tools/xdelta3.exe") {
    Write-Host "xdelta3 already installed" -ForegroundColor Green
} else {
    Write-Host "downloading xdelta3" -ForegroundColor Cyan
    $xdeltaUrl = "https://github.com/jmacd/xdelta-gpl/releases/download/v3.0.11/xdelta3-3.0.11-x86_64.exe.zip"
    try {
        Invoke-WebRequest -Uri $xdeltaUrl -OutFile "xdelta.zip"
        Expand-Archive "xdelta.zip" -DestinationPath "./Tools"
        Move-Item "./Tools/xdelta3-3.0.11-x86_64.exe" "./Tools/xdelta3.exe" -Force
        Remove-Item "xdelta.zip"
        Write-Host "xdelta3 installed" -ForegroundColor Green
    } catch {
        Write-Error "xdelta3 download failed. Please manually place xdelta3.exe in the ./Tools folder."
    }
}
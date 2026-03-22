# Windows Tool Installer (Full Version)

$tools = @(
    # 🌐 Browser
    @{ Name = "Google Chrome"; Id = "Google.Chrome" },
    @{ Name = "Mozilla Firefox"; Id = "Mozilla.Firefox" },
    @{ Name = "Brave Browser"; Id = "Brave.Brave" },

    # 💻 Development
    @{ Name = "Visual Studio Code"; Id = "Microsoft.VisualStudioCode" },
    @{ Name = "Git"; Id = "Git.Git" },
    @{ Name = "GitHub Desktop"; Id = "GitHub.GitHubDesktop" },
    @{ Name = "GitHub CLI"; Id = "GitHub.cli" },
    @{ Name = "Node.js"; Id = "OpenJS.NodeJS" },
    @{ Name = "Python"; Id = "Python.Python.3" },
    @{ Name = "Docker Desktop"; Id = "Docker.DockerDesktop" },

    # 🧰 Utilities
    @{ Name = "7-Zip"; Id = "7zip.7zip" },
    @{ Name = "WinRAR"; Id = "RARLab.WinRAR" },
    @{ Name = "Everything Search"; Id = "voidtools.Everything" },
    @{ Name = "PowerToys"; Id = "Microsoft.PowerToys" },
    @{ Name = "Notepad++"; Id = "Notepad++.Notepad++" },
    @{ Name = "ShareX"; Id = "ShareX.ShareX" },

    # 📊 System Tools
    @{ Name = "Sysinternals Suite"; Id = "Microsoft.Sysinternals" },
    @{ Name = "Process Explorer"; Id = "Microsoft.ProcessExplorer" },
    @{ Name = "HWMonitor"; Id = "CPUID.HWMonitor" },

    # 🎧 Media
    @{ Name = "VLC Player"; Id = "VideoLAN.VLC" },
    @{ Name = "Spotify"; Id = "Spotify.Spotify" },

    # 💬 Kommunikation
    @{ Name = "Discord"; Id = "Discord.Discord" },
    @{ Name = "Microsoft Teams"; Id = "Microsoft.Teams" },
    @{ Name = "Telegram"; Id = "Telegram.TelegramDesktop" },

    # ☁️ Cloud
    @{ Name = "Google Drive"; Id = "Google.Drive" },
    @{ Name = "Dropbox"; Id = "Dropbox.Dropbox" },

    # 🎮 Gaming
    @{ Name = "Steam"; Id = "Valve.Steam" },
    @{ Name = "Epic Games Launcher"; Id = "EpicGames.EpicGamesLauncher" },

    # 🔐 Security
    @{ Name = "Malwarebytes"; Id = "Malwarebytes.Malwarebytes" },
    @{ Name = "Bitwarden"; Id = "Bitwarden.Bitwarden" }
)

function Show-Menu {
    Clear-Host
    Write-Host "=== Windows Tool Installer ===" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $tools.Count; $i++) {
        $num = $i + 1
        Write-Host ("[{0}] {1}" -f $num, $tools[$i].Name)
    }

    Write-Host ""
    Write-Host "[A] Alle installieren"
    Write-Host "[Q] Beenden"
    Write-Host ""
}

function Install-Tools {
    param ([array]$indexes)

    foreach ($i in $indexes) {
        $tool = $tools[$i]

        Write-Host ""
        Write-Host ("Installiere: {0}" -f $tool.Name) -ForegroundColor Green

        try {
            winget install --id $tool.Id -e `
                --accept-package-agreements `
                --accept-source-agreements
        }
        catch {
            Write-Host ("Fehler bei: {0}" -f $tool.Name) -ForegroundColor Red
        }
    }
}

# winget check
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget nicht gefunden! Bitte App Installer installieren." -ForegroundColor Red
    exit 1
}

Show-Menu
$input = Read-Host "Nummern eingeben (z.B. 1,5,10) oder A"

if ($input.ToUpper() -eq "Q") {
    Write-Host "Abgebrochen."
    exit
}

if ($input.ToUpper() -eq "A") {
    Install-Tools (0..($tools.Count - 1))
    Write-Host ""
    Write-Host "Alle Tools installiert!" -ForegroundColor Cyan
    exit
}

# Eingabe verarbeiten
$indexes = @()

foreach ($item in ($input -split ",")) {
    $item = $item.Trim()

    if ($item -match '^\d+$') {
        $index = [int]$item - 1

        if ($index -ge 0 -and $index -lt $tools.Count) {
            $indexes += $index
        } else {
            Write-Host "Ungültige Nummer: $item" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Ungültige Eingabe: $item" -ForegroundColor Yellow
    }
}

$indexes = $indexes | Sort-Object -Unique

if ($indexes.Count -eq 0) {
    Write-Host "Keine gültige Auswahl!" -ForegroundColor Red
    exit
}

Install-Tools $indexes

Write-Host ""
Write-Host "Installation abgeschlossen!" -ForegroundColor Cyan

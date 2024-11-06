# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Output "winget not found. Please install winget manually."
    exit 1
}

# Check if Npcap is installed
$npcap = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "Npcap" }
if (-not $npcap) {
    Write-Output "Npcap not found. Installing using winget..."
    winget install -e --id Nmap.Npcap
} else {
    Write-Output "Npcap is already installed."
}

Write-Output "All dependencies are installed."


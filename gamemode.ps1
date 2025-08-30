# Script PowerShell para desativar serviços inúteis para jogos
# Execute como Administrador

# Lista de serviços considerados desnecessários para jogos
$services = @(
    "Fax",
    "Spooler", # Print Spooler
    "RemoteRegistry",
    "seclogon", # Secondary Logon
    "TabletInputService", # Touch Keyboard and Handwriting Panel
    "WerSvc", # Windows Error Reporting
    "SCardSvr", # Smart Card
    "ScDeviceEnum", # Smart Card Device Enumeration
    "PhoneSvc", # Phone Service
    "MapsBroker", # Downloaded Maps Manager
    "XblAuthManager", # Xbox Live Auth
    "XblGameSave", # Xbox Live Game Save
    "XboxNetApiSvc", # Xbox Live Networking
    "RetailDemo" # Retail Demo Service
)

foreach ($svc in $services) {
    $svcObj = Get-Service -Name $svc -ErrorAction SilentlyContinue

    if ($null -ne $svcObj) {
        Write-Host ""
        Write-Host "Serviço encontrado: $($svcObj.DisplayName) ($svc)" -ForegroundColor Cyan
        Write-Host "Status atual: $($svcObj.Status), Inicialização: $(Get-WmiObject Win32_Service -Filter "Name='$svc'" | Select-Object -ExpandProperty StartMode)"
        $choice = Read-Host "Deseja desativar este serviço? (Y/n)"
        
        if ($choice -eq "Y" -or $choice -eq "y" -or $choice -eq "") {
            try {
                Set-Service -Name $svc -StartupType Disabled -ErrorAction Stop
                Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
                Write-Host "✅ Serviço $svc desativado com sucesso." -ForegroundColor Green
            } catch {
                Write-Host "❌ Erro ao desativar $svc: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "⏭ Serviço $svc mantido ativo." -ForegroundColor Yellow
        }
    } else {
        Write-Host "⚠ Serviço $svc não encontrado neste Windows." -ForegroundColor DarkGray
    }
}


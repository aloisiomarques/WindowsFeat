# Execute como Administrador

# Lista de serviços com nomes amigáveis e técnicos
$services = @{
    "Fax"                             = "Fax"
    "Print Spooler"                   = "Spooler"
    "Windows Search"                  = "WSearch"
    "Error Reporting"                 = "WerSvc"
    "Remote Registry"                = "RemoteRegistry"
    "Tablet Input / Handwriting"      = "TabletInputService"
    "Telemetry / DiagTrack"           = "DiagTrack"
    "Bluetooth Audio Gateway"         = "BTAGService"
    "Bluetooth Support"               = "bthserv"
    "WMP Network Sharing"             = "WMPNetworkSvc"
    "Xbox Game Save"                  = "XblGameSave"
    "Xbox Networking"                 = "XboxNetApiSvc"
    "Xbox Accessory"                  = "XboxGipSvc"
    "Windows Insider Service"         = "wisvc"
    "Link Tracking Client"            = "TrkWks"
    "Superfetch (SysMain)"            = "SysMain"
    "Retail Demo Service"             = "RetailDemo"
}

# Função para confirmar com Y/n
function Confirmar($mensagem) {
    do {
        $resposta = Read-Host "$mensagem (Y/n)"
        if ($resposta -eq '') { $resposta = 'Y' }
    } while ($resposta -notmatch '^[YyNn]$')

    return $resposta -match '^[Yy]$'
}

# Loop para cada serviço
foreach ($nomeAmigavel in $services.Keys) {
    $nomeServico = $services[$nomeAmigavel]
    if (Get-Service -Name $nomeServico -ErrorAction SilentlyContinue) {
        if (Confirmar "Deseja desativar o serviço: $nomeAmigavel") {
            Write-Host "-> Desativando: $nomeAmigavel ($nomeServico)"
            Set-Service -Name $nomeServico -StartupType Disabled -ErrorAction SilentlyContinue
            Stop-Service -Name $nomeServico -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "-> Mantido: $nomeAmigavel"
        }
    } else {
        Write-Host "-> Serviço não encontrado: $nomeAmigavel ($nomeServico)"
    }
}

Write-Host "`nFinalizado. Os serviços selecionados foram desativados."


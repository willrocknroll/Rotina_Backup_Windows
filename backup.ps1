# Defina o caminho da pasta de origem (que será copiada)
$origem = "C:\Users\willian\Desktop\Certificados VPN"

# Defina o caminho da pasta raiz no HD externo
$destinoRaiz = "Z:\BackupPS"  # Ajuste conforme sua unidade

# Cria a pasta raiz de destino se ela não existir
if (!(Test-Path -Path $destinoRaiz)) {
    New-Item -ItemType Directory -Path $destinoRaiz
}

# Cria uma subpasta com data e hora para o backup
$dataHora = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$destino = Join-Path -Path $destinoRaiz -ChildPath $dataHora
New-Item -ItemType Directory -Path $destino | Out-Null

# Executa o backup com Robocopy
Robocopy $origem $destino /MIR /Z /XA:H /W:5 /R:3 /LOG:"$env:USERPROFILE\backup_log.txt"

# Mantém apenas as 5 cópias mais recentes
$pastasBackup = Get-ChildItem -Path $destinoRaiz -Directory | Sort-Object Name -Descending
$pastasExcluir = $pastasBackup | Select-Object -Skip 5

foreach ($pasta in $pastasExcluir) {
    try {
        Remove-Item -Path $pasta.FullName -Recurse -Force
        Write-Host "Pasta antiga removida: $($pasta.FullName)" -ForegroundColor Yellow
    } catch {
        Write-Host "Erro ao remover a pasta: $($pasta.FullName). Erro: $_" -ForegroundColor Red
    }
}

Write-Host "Backup concluído com sucesso! Cópia criada em: $destino" -ForegroundColor Green

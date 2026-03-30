# ============================================================
#  COLETA DE INFORMACOES DO SISTEMA
#  Criado por Analista Renata Scheiner
# ============================================================

$Host.UI.RawUI.WindowTitle = "White Teams | Coleta de Informacoes do Sistema"

# Caminho de saida
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$Output = "$DesktopPath\info_sistema_$env:COMPUTERNAME.txt"

Clear-Host
Write-Host ""
Write-Host "  +======================================================+" -ForegroundColor Cyan
Write-Host "  |   TEAM INFRA  -  Controle de Identidade             |" -ForegroundColor Cyan
Write-Host "  |        Coleta de Informacoes do Sistema              |" -ForegroundColor Cyan
Write-Host "  +======================================================+" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Maquina  : $env:COMPUTERNAME"
Write-Host "   Usuario  : $env:USERNAME"
Write-Host "   Data     : $(Get-Date -Format 'dd/MM/yyyy   Hora: HH:mm:ss')"
Write-Host ""
Write-Host "  ------------------------------------------------------"
Write-Host "   Por favor, aguarde. NAO feche esta janela!"
Write-Host "  ------------------------------------------------------"
Write-Host ""

# Cabecalho do arquivo
@"
============================================================
       OUTPUT DE INFORMACOES DO SISTEMA
       White Teams - Controle de Identidade e Conformidade
============================================================
Data/Hora : $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')
Maquina   : $env:COMPUTERNAME

"@ | Out-File -FilePath $Output -Encoding UTF8

function Write-Section {
    param($Title, $Content)
    @"
[$Title]
$Content

"@ | Out-File -FilePath $Output -Encoding UTF8 -Append
}

# ── [1/11] Usuario Logado
Write-Host "   [ 1 / 11 ]  Usuario logado..." -NoNewline
Write-Section "Usuario Logado" (whoami)
Write-Host "   OK!" -ForegroundColor Green

# ── [2/11] Hostname
Write-Host "   [ 2 / 11 ]  Hostname..." -NoNewline
Write-Section "Hostname" (hostname)
Write-Host "   OK!" -ForegroundColor Green

# ── [3/11] Endereco IP
Write-Host "   [ 3 / 11 ]  Endereco IP..." -NoNewline
$IPs = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.PrefixOrigin -ne 'WellKnown' }).IPAddress
Write-Section "Endereco IP" ($IPs -join "`n")
Write-Host "   OK!" -ForegroundColor Green

# ── [4/11] Adaptadores de Rede
Write-Host "   [ 4 / 11 ]  Adaptadores de rede e MAC Address..." -NoNewline
$Adapters = Get-NetAdapter | Select-Object Name, MacAddress | Format-Table -AutoSize | Out-String
Write-Section "Adaptadores de Rede - Nome e MAC Address" $Adapters.Trim()
Write-Host "   OK!" -ForegroundColor Green

# ── [5/11] Sistema Operacional
Write-Host "   [ 5 / 11 ]  Sistema Operacional e modelo..." -NoNewline
$OS      = (Get-CimInstance Win32_OperatingSystem).Caption
$Model   = (Get-CimInstance Win32_ComputerSystem).Model
$Install = (Get-CimInstance Win32_OperatingSystem).InstallDate | Get-Date -Format 'dd/MM/yyyy'
@"
[Sistema Operacional]
$OS

[Modelo do Sistema]
$Model

[Data de Instalacao do Sistema]
$Install

"@ | Out-File -FilePath $Output -Encoding UTF8 -Append
Write-Host "   OK!" -ForegroundColor Green

# ── [6/11] BIOS
Write-Host "   [ 6 / 11 ]  Informacoes da BIOS..." -NoNewline
$BIOSVer    = (Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion
$BIOSSerial = (Get-CimInstance Win32_BIOS).SerialNumber
@"
[Versao da BIOS]
$BIOSVer

[Numero de Serie da BIOS]
$BIOSSerial

"@ | Out-File -FilePath $Output -Encoding UTF8 -Append
Write-Host "   OK!" -ForegroundColor Green

# ── [7/11] Processador
Write-Host "   [ 7 / 11 ]  Processador..." -NoNewline
Write-Section "Modelo do Processador" (Get-CimInstance Win32_Processor).Name
Write-Host "   OK!" -ForegroundColor Green

# ── [8/11] Memoria RAM
Write-Host "   [ 8 / 11 ]  Memoria RAM..." -NoNewline
$RAM = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2).ToString() + ' GB'
Write-Section "Memoria RAM Total" $RAM
Write-Host "   OK!" -ForegroundColor Green

# ── [9/11] HD Fisico
Write-Host "   [ 9 / 11 ]  Disco fisico..." -NoNewline
$Disks = Get-PhysicalDisk | ForEach-Object { [math]::Round($_.Size / 1GB, 2).ToString() + ' GB' }
Write-Section "Tamanho Fisico do HD" ($Disks -join "`n")
Write-Host "   OK!" -ForegroundColor Green

# ── [10/11] Windows Defender
Write-Host "   [ 10 / 11 ] Windows Defender..." -NoNewline
$Defender     = Get-MpComputerStatus | Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, RealTimeProtectionEnabled, BehaviorMonitorEnabled, IoavProtectionEnabled, IsTamperProtected | Format-List | Out-String
$DefenderDate = (Get-MpComputerStatus).AntivirusSignatureLastUpdated
@"
[Status do Windows Defender]
$($Defender.Trim())

[Data da Ultima Atualizacao do Antivirus - Defender]
$DefenderDate

"@ | Out-File -FilePath $Output -Encoding UTF8 -Append
Write-Host "   OK!" -ForegroundColor Green

# ── [11/11] Chave de Licenca do Windows
Write-Host "   [ 11 / 11 ] Chave de licenca do Windows..." -NoNewline
$Key = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform').BackupProductKeyDefault
if (-not $Key) { $Key = "Chave nao encontrada (licenca digital ou OEM vinculada ao hardware)" }
Write-Section "Chave de Licenca do Windows" $Key
Write-Host "   OK!" -ForegroundColor Green

# ── Assinatura
@"
------------------------------------------------------------
 Criado por Analista Renata Scheiner
 White Teams - Controle de Identidade e Conformidade
------------------------------------------------------------
"@ | Out-File -FilePath $Output -Encoding UTF8 -Append

# ── Tela final
Clear-Host
Write-Host ""
Write-Host "  +======================================================+" -ForegroundColor Cyan
Write-Host "  |        WHITE TEAMS  -  Coleta Concluida!            |" -ForegroundColor Cyan
Write-Host "  +======================================================+" -ForegroundColor Cyan
Write-Host ""
Write-Host "   [OK]  Usuario logado"             -ForegroundColor Green
Write-Host "   [OK]  Hostname"                   -ForegroundColor Green
Write-Host "   [OK]  Endereco IP e Adaptadores"  -ForegroundColor Green
Write-Host "   [OK]  Sistema Operacional e Modelo" -ForegroundColor Green
Write-Host "   [OK]  BIOS e Numero de Serie"     -ForegroundColor Green
Write-Host "   [OK]  Processador"                -ForegroundColor Green
Write-Host "   [OK]  Memoria RAM"                -ForegroundColor Green
Write-Host "   [OK]  Disco Fisico"               -ForegroundColor Green
Write-Host "   [OK]  Windows Defender"           -ForegroundColor Green
Write-Host "   [OK]  Chave de Licenca do Windows" -ForegroundColor Green
Write-Host ""
Write-Host "  ------------------------------------------------------"
Write-Host "   Relatorio salvo em:"
Write-Host "   $Output" -ForegroundColor Yellow
Write-Host "  ------------------------------------------------------"
Write-Host ""
Write-Host "   IMPORTANTE: Nao esqueca de preencher a planilha!"
Write-Host "   Controle de Identidade e Conformidade - White Teams"
Write-Host ""
Write-Host "  ------------------------------------------------------"
Write-Host "   Voce ja pode fechar esta janela."
Write-Host "  ------------------------------------------------------"
Write-Host ""
Read-Host "  Pressione ENTER para fechar"

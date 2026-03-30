# ============================================
#   EXTRATOR DE LICENÇA DO WINDOWS
#   Execute como Administrador
# ============================================

$ErrorActionPreference = "SilentlyContinue"

function Write-Header {
    param([string]$Titulo)
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "  $Titulo" -ForegroundColor Cyan
    Write-Host "============================================" -ForegroundColor Cyan
}

function Write-Item {
    param([string]$Label, [string]$Valor)
    Write-Host ("  {0,-22} " -f $Label) -NoNewline -ForegroundColor Gray
    if ($Valor -and $Valor.Trim() -ne "") {
        Write-Host $Valor -ForegroundColor Green
    } else {
        Write-Host "Nao encontrado" -ForegroundColor DarkGray
    }
}

Clear-Host
Write-Host ""
Write-Host "  EXTRATOR DE LICENCA DO WINDOWS" -ForegroundColor Blue
Write-Host "  $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -ForegroundColor DarkGray
Write-Host ""

# 1. SISTEMA
Write-Header "INFORMACOES DO SISTEMA"
$os = Get-WmiObject Win32_OperatingSystem
$cs = Get-WmiObject Win32_ComputerSystem
Write-Item "Sistema Operacional:" $os.Caption
Write-Item "Versao:" $os.Version
Write-Item "Build:" $os.BuildNumber
Write-Item "Arquitetura:" $os.OSArchitecture
Write-Item "Computador:" $cs.Name
Write-Item "Fabricante:" $cs.Manufacturer
Write-Item "Modelo:" $cs.Model

# 2. CHAVE OEM
Write-Header "CHAVE OEM (BIOS/UEFI)"
$chaveOEM = (Get-WmiObject -Query "SELECT OA3xOriginalProductKey FROM SoftwareLicensingService").OA3xOriginalProductKey
Write-Item "Chave OEM:" $chaveOEM
if (-not $chaveOEM) {
    Write-Host "  Licenca Digital - chave vinculada ao hardware/conta Microsoft." -ForegroundColor Yellow
}

# 3. CHAVE VIA REGISTRO
Write-Header "CHAVE VIA REGISTRO DO WINDOWS"
$productKey = ""
try {
    $key = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DigitalProductId
    $keyOffset = 52
    $isWin8 = [System.Math]::Truncate($key[66] / 6) -band 1
    $key[66] = ($key[66] -band 0xF7) -bor (($isWin8 -band 2) * 4)
    $chars = "BCDFGHJKMPQRTVWXY2346789"
    $i = 24
    do {
        $cur = 0; $j = 14
        do {
            $cur = $cur * 256
            $cur = $key[$j + $keyOffset] + $cur
            $key[$j + $keyOffset] = [System.Math]::Truncate($cur / 24)
            $cur = $cur % 24
            $j--
        } while ($j -ge 0)
        $i--
        $productKey = $chars[$cur] + $productKey
        if (($i % 5) -eq 0 -and $i -ne 0) { $productKey = "-" + $productKey }
    } while ($i -ge 0)
    Write-Item "Chave (Registro):" $productKey
} catch {
    Write-Item "Chave (Registro):" ""
}

# 4. STATUS DE ATIVAÇÃO
Write-Header "STATUS DE ATIVACAO"
$licencas = Get-WmiObject -Query "SELECT * FROM SoftwareLicensingProduct WHERE PartialProductKey IS NOT NULL AND Name LIKE 'Windows%'"
$linhasLicenca = @()
foreach ($lic in $licencas) {
    $statusTexto = switch ($lic.LicenseStatus) {
        0 { "Sem Licenca" } 1 { "Ativado" } 2 { "Graca OOB" }
        3 { "Graca OOT" } 4 { "Nao Genuino" } 5 { "Notificacao" }
        6 { "Graca Estendido" } default { "Desconhecido" }
    }
    $statusCor = if ($lic.LicenseStatus -eq 1) { "Green" } else { "Red" }
    Write-Item "Edicao:" $lic.Name
    Write-Item "Chave Parcial:" ("*****-*****-*****-*****-" + $lic.PartialProductKey)
    Write-Item "Canal da Licenca:" $lic.ProductKeyChannel
    Write-Host ("  {0,-22} " -f "Status:") -NoNewline -ForegroundColor Gray
    Write-Host $statusTexto -ForegroundColor $statusCor
    Write-Host ""
    $linhasLicenca += "  Edicao:        $($lic.Name)"
    $linhasLicenca += "  Chave Parcial: *****-*****-*****-*****-$($lic.PartialProductKey)"
    $linhasLicenca += "  Canal:         $($lic.ProductKeyChannel)"
    $linhasLicenca += "  Status:        $statusTexto"
    $linhasLicenca += ""
}

# 5. SLMGR
Write-Header "DETALHES ADICIONAIS (slmgr)"
$slmgr = cscript //nologo "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1
$slmgrFiltrado = $slmgr | Where-Object { $_ -match "Nome|Tipo|Licen|Status|Prazo|Partial|Channel" }
$slmgrFiltrado | ForEach-Object { Write-Host "  $_" -ForegroundColor White }

# 6. SALVAR
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
$resposta = Read-Host "  Deseja salvar o resultado em um TXT? (S/N)"

if ($resposta -match "^[Ss]$") {
    $caminho = "$env:USERPROFILE\Desktop\licenca_windows_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

    $linhas = [System.Collections.Generic.List[string]]::new()
    $linhas.Add("============================================")
    $linhas.Add("  EXTRATOR DE LICENCA DO WINDOWS")
    $linhas.Add("  Gerado em: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')")
    $linhas.Add("============================================")
    $linhas.Add("")
    $linhas.Add("[SISTEMA]")
    $linhas.Add("  SO:           $($os.Caption)")
    $linhas.Add("  Versao:       $($os.Version)")
    $linhas.Add("  Build:        $($os.BuildNumber)")
    $linhas.Add("  Arquitetura:  $($os.OSArchitecture)")
    $linhas.Add("  Computador:   $($cs.Name)")
    $linhas.Add("  Fabricante:   $($cs.Manufacturer)")
    $linhas.Add("  Modelo:       $($cs.Model)")
    $linhas.Add("")
    $linhas.Add("[CHAVE OEM (BIOS/UEFI)]")
    if ($chaveOEM) { $linhas.Add("  $chaveOEM") } else { $linhas.Add("  Nao encontrada (Licenca Digital)") }
    $linhas.Add("")
    $linhas.Add("[CHAVE VIA REGISTRO]")
    if ($productKey) { $linhas.Add("  $productKey") } else { $linhas.Add("  Nao encontrada") }
    $linhas.Add("")
    $linhas.Add("[STATUS DE ATIVACAO]")
    foreach ($l in $linhasLicenca) { $linhas.Add($l) }
    $linhas.Add("")
    $linhas.Add("[DETALHES SLMGR]")
    foreach ($l in $slmgrFiltrado) { $linhas.Add("  $l") }

    try {
        [System.IO.File]::WriteAllLines($caminho, $linhas, [System.Text.Encoding]::UTF8)
        Write-Host ""
        if (Test-Path $caminho) {
            Write-Host "  Arquivo salvo com sucesso!" -ForegroundColor Green
            Write-Host "  $caminho" -ForegroundColor Yellow
        } else {
            Write-Host "  ERRO: arquivo nao foi criado." -ForegroundColor Red
        }
    } catch {
        Write-Host "  ERRO ao salvar: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "  Pressione ENTER para sair..." -ForegroundColor DarkGray
Read-Host

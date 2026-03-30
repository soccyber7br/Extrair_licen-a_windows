# 🖥️ INFO SYSTEM - Coleta de Informações do Windows

Script em PowerShell para coleta automatizada de informações de sistema, voltado para inventário, auditoria e controle de conformidade em ambientes corporativos.

## 📌 Objetivo

Centralizar informações críticas do host em um único output estruturado, facilitando:

- Inventário de ativos
- Auditoria de endpoints
- Validação de conformidade
- Troubleshooting rápido

## ⚙️ Funcionalidades

O script coleta e registra:

- Usuário logado (`whoami`)
- Hostname
- Endereços IP (IPv4 válidos)
- Adaptadores de rede + MAC Address
- Sistema operacional + modelo da máquina
- Data de instalação do SO
- Informações de BIOS (versão + serial)
- Processador
- Memória RAM total
- Discos físicos (tamanho)
- Status do Windows Defender:
  - Antivirus
  - Real-time protection
  - Tamper protection
  - Última atualização de assinatura
- Chave de licença do Windows (quando disponível)

## 📂 Output

O relatório é salvo automaticamente na área de trabalho.

⚠️ Observações

A chave de licença pode não ser retornada em sistemas com:
Licença digital (Microsoft Account)
OEM vinculada ao hardware
Get-PhysicalDisk pode exigir privilégios elevados dependendo do ambiente
Get-MpComputerStatus requer Windows Defender ativo

🛡️ Uso em Segurança / Blue Team

Esse script é útil para:

Baseline de máquinas
Coleta rápida em incident response
Validação de hardening básico
Integração manual com planilhas de controle (IAM / Compliance)

🧱 Estrutura

Função auxiliar para escrita (Write-Section)
Execução sequencial por etapas [1/11]
Output padronizado em TXT
Interface CLI simples com feedback visual

✍️ Autor

Analista Renata Scheiner
Controle de Identidade e Conformidade

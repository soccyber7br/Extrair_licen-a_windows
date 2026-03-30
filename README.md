# 🔑 Windows License Extractor

> Ferramenta PowerShell para extração segura de chaves de licença do Windows — ideal para ambientes corporativos com hardware comprometido ou máquinas condenadas.

---

## 📋 Sobre o Projeto

O **Windows License Extractor** é um script PowerShell leve, sem dependências externas, que extrai e exibe informações completas sobre a licença do Windows instalada em uma máquina. Ele foi desenvolvido pensando em equipes de TI corporativa que precisam recuperar licenças de máquinas com falha de hardware antes do descarte ou substituição.

Nenhum dado é enviado para servidores externos. Tudo roda localmente na máquina.

---

## ⚙️ O que o script faz

- Exibe informações completas do sistema operacional (versão, build, arquitetura, fabricante, modelo)
- Tenta extrair a **chave OEM gravada na BIOS/UEFI** via WMI
- Decodifica a **chave armazenada no Registro do Windows** (`DigitalProductId`)
- Exibe o **status de ativação** da licença (Ativado, Sem Licença, Período de Graça, etc.)
- Mostra o **canal da licença** (OEM, Retail, Volume)
- Consulta o `slmgr.vbs` para detalhes adicionais de licenciamento
- Permite **exportar tudo para um arquivo `.txt`** na Área de Trabalho com timestamp

---

## 🗂️ Arquivos

| Arquivo | Descrição |
|---|---|
| `extrair_licenca.ps1` | Script principal PowerShell |
| `extrair_licenca.bat` | Atalho para executar o `.ps1` sem alterar políticas do sistema |

---

## 🚀 Como usar

### Pré-requisitos

- Windows 7 / 8 / 10 / 11
- PowerShell 3.0 ou superior (já incluso no Windows 8+)
- Privilégios de **Administrador**

### Opção 1 — Via `.bat` (mais fácil)

1. Coloque `extrair_licenca.ps1` e `rodar_licenca.bat` na **mesma pasta**
2. Clique com o botão direito em `rodar_licenca.bat`
3. Selecione **"Executar como administrador"**

### Opção 2 — Via PowerShell diretamente

Abra o PowerShell como Administrador e execute:

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
& "C:\caminho\para\extrair_licenca.ps1"
```

### Salvando o resultado

Ao final da execução, o script pergunta se deseja salvar um relatório `.txt`. Se confirmar, o arquivo será gerado na Área de Trabalho com o nome:

```
licenca_windows_20260330_143022.txt
```

---

## 🔒 Segurança

Este script foi desenvolvido com foco total em **segurança e transparência**:

- ✅ **100% local** — nenhuma conexão de rede é realizada, nenhum dado é transmitido
- ✅ **Código aberto** — todo o código é legível e auditável
- ✅ **Sem instalação** — não instala nada no sistema, não modifica o registro
- ✅ **Somente leitura** — apenas lê informações já existentes no sistema
- ✅ **Sem dependências externas** — usa apenas APIs nativas do Windows (WMI, Registry, slmgr)
- ✅ **Sem privilégios persistentes** — os privilégios de administrador são usados apenas durante a execução

> ⚠️ Recomendamos sempre revisar o código-fonte antes de executar qualquer script com privilégios de administrador — inclusive este.

---

## 🏢 Casos de uso corporativo

### Recuperação de licenças em hardware condenado

Quando um computador corporativo apresenta falha irreparável de hardware (placa-mãe queimada, SSD corrompido, dano físico), a licença do Windows pode ser recuperada antes do descarte, desde que seja uma licença **Retail** ou **licença de volume** gerenciada pelo seu KMS/MAK.

**Fluxo recomendado:**

```
1. Execute o script na máquina com problema (se ainda der boot)
2. Salve o relatório .txt com as informações da licença
3. Registre no inventário de TI
4. Utilize a chave para reativar em nova máquina (se aplicável ao tipo de licença)
```

### Inventário de licenças

Útil para mapear o parque de máquinas de uma empresa e identificar:
- Máquinas com licenças não ativadas
- Tipo de canal de cada licença (OEM, Retail, Volume)
- Versão e build exata do Windows em cada estação

### Migração de hardware

Durante trocas de equipamentos em lote, o script permite extrair e documentar todas as chaves antes da formatação das máquinas antigas.

---

## ⚖️ Tipos de licença e reutilização

É importante entender as limitações legais de cada tipo de licença:

| Tipo | Transferível? | Observação |
|---|---|---|
| **OEM** | ❌ Não | Vinculada ao hardware original pelo fabricante |
| **Retail (Caixa/ESD)** | ✅ Sim | Pode ser transferida para outro hardware |
| **Volume (KMS/MAK)** | Depende do contrato | Gerenciado pelo administrador de licenças da empresa |
| **Digital License** | ❌ Não diretamente | Vinculada à conta Microsoft e ao hardware |

> 📌 Sempre consulte o contrato de licenciamento da Microsoft (EULA) e o departamento jurídico da sua empresa antes de reutilizar licenças. O uso indevido de licenças OEM em outros equipamentos pode violar os termos de uso.

---

## 🧩 Limitações conhecidas

- Licenças **digitais** (vinculadas à conta Microsoft) não possuem chave de produto visível — isso é esperado e não é um erro do script
- Em máquinas com **licença de volume KMS**, a chave exibida pode ser a chave genérica de instalação (GVLK), não a chave MAK real
- Requer acesso ao sistema operacional em funcionamento — não funciona em discos corrompidos ou sem boot

---

## 🛠️ Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir uma _issue_ ou enviar um _pull request_ com melhorias, correções ou novos recursos.

---

## 📄 Bugs

O codificação de saída precisa ser recodificada. Próximo commit pretendo ajustar.

---

> Desenvolvido para facilitar a vida de equipes de TI corporativa. Use com responsabilidade.

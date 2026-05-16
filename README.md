# 🦈 INFO SYSTEM 3.3 — Coleta de Informações do Sistema Windows

Ferramenta em PowerShell para inventário rápido e coleta automatizada de informações do sistema operacional Windows.

O script gera relatórios detalhados em **TXT** ou **PDF**, contendo informações de hardware, rede, segurança e criptografia da máquina.

Ideal para equipes de:

- Infraestrutura
- Service Desk
- Suporte Técnico
- Auditoria
- Inventário de ativos
- Controle de identidade
- Troubleshooting corporativo

---

# 📋 Funcionalidades

## ✅ Coleta automática de informações do sistema

O script realiza a coleta dos seguintes dados:

### 👤 Usuário logado
- Usuário atualmente autenticado na máquina

### 🖥️ Hostname
- Nome do computador

### 🌐 Endereços IP
- Lista de IPs IPv4 ativos

### 🔌 Adaptadores de rede
- Nome dos adaptadores
- Endereço MAC

### 💻 Sistema operacional
- Nome e versão do Windows

### 🔐 BIOS
- Serial da BIOS

### ⚙️ Processador (CPU)
- Modelo do processador instalado

### 🧠 Memória RAM
- Quantidade total de RAM instalada

### 💾 Discos físicos
- Tamanho dos discos em GB

### 🛡️ Windows Defender
- Status do antivírus
- Status da proteção em tempo real

### 🔑 Licença do Windows
- Chave de ativação do sistema operacional

### 🔒 BitLocker
- Recovery Keys do BitLocker
- Identificadores das chaves
- Unidades criptografadas

---

# 📄 Exportação de Relatórios

O usuário pode escolher entre:

## 1️⃣ TXT
Relatório simples em texto.

## 2️⃣ PDF
Conversão automática utilizando:
- `Microsoft Print to PDF`

---

# 🖥️ Interface Console

O script possui:
- Interface amigável em terminal
- Barra sequencial de progresso
- Feedback visual de execução
- Mensagens de status em tempo real

---

# 📂 Local de saída

Os relatórios são salvos automaticamente na:

```powershell
Desktop do usuário atual

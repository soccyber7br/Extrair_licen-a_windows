@echo off
setlocal

REM ============================================================
REM  LAUNCHER - INFO SYSTEM 3.1
REM  Executa o script PowerShell como Administrador
REM ============================================================

REM Verifica se ja esta rodando como admin
net session >nul 2>&1
if %errorlevel% == 0 goto :RUN

REM Se nao for admin, relanca como admin automaticamente
echo  Solicitando privilegios de Administrador...
powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
exit /b

:RUN
REM Caminho do .ps1 na mesma pasta do .bat
set "PS1=%~dp0INFO_SYSTEM_3_1.ps1"

if not exist "%PS1%" (
    echo.
    echo  ERRO: Arquivo INFO_SYSTEM_3_1.ps1 nao encontrado!
    echo  Certifique-se de que o .ps1 esta na mesma pasta que este .bat
    echo.
    pause
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

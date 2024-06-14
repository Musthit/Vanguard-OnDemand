@echo off

echo Comprobando si VGC Service está habilitado...
sc query vgc | find "ESTADO" | find "STOPPED"
if %ERRORLEVEL% EQU 0 (
    echo VGC Service está deshabilitado. Habilitándolo...
    sc config vgc start=auto
    echo Esperando 2 segundos para aplicar el cambio...
    timeout /t 2 >NUL
    echo Iniciando VGC Service...
    sc start vgc
) else (
    echo VGC Service está habilitado. Iniciando...
    sc start vgc
)

echo Comprobando si Vanguard Tray está deshabilitado...
tasklist /FI "IMAGENAME eq vgtray.exe" 2>NUL | find /I "vgtray.exe" >NUL
if %ERRORLEVEL% NEQ 0 (
    echo Vanguard Tray no está en ejecución. Iniciando...
    start "" "C:\Program Files\Riot Vanguard\vgtray.exe"
) else (
    echo Vanguard Tray ya está en ejecución.
)

echo Iniciando Riot Client...
start "" "D:\Games\Riot Games\Riot Client\RiotClientServices.exe
echo Esperando a que League of Legends inicie...
timeout /t 60

:check
tasklist /FI "IMAGENAME eq LeagueClient.exe" 2>NUL | find /I "LeagueClient.exe" >NUL
if %ERRORLEVEL% EQU 0 (
    echo League of Legends sigue en ejecución...
    timeout /t 10
    goto check
) else (
    echo League of Legends se ha cerrado. Deteniendo Vanguard...

   

    echo Vanguard se ha detenido.

    echo Deshabilitando VGC Service...
    sc stop vgc >NUL
    sc config vgc start=disabled >NUL
    echo VGC Service ha sido deshabilitado.

    pause

    taskkill /F /IM vgtray.exe >NUL 2>&1
    echo Correcto: se terminó el proceso "vgtray.exe".
   


)

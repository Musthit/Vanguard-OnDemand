@echo off
echo Iniciando VGC Service...
start "VGC Service" sc start vgc

echo Iniciando VGC Tray...
start "VGC Tray" "C:\Program Files\Riot Vanguard\vgtray.exe"

echo Iniciando Riot Client...
start "Riot Client" "D:\Games\Riot Games\League of Legends\LeagueClient.exe" --launch-product=league_of_legends --launch-patchline=live

echo Esperando a que League of Legends inicie...
timeout /t 30

:check
tasklist /FI "IMAGENAME eq LeagueClient.exe" 2>NUL | find /I "LeagueClient.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo League of Legends sigue en ejecución...
    timeout /t 10
    goto check
) else (
    echo League of Legends se ha cerrado. Deteniendo Vanguard...
    taskkill /IM vgtray.exe /F
    sc stop vgc
    echo Vanguard se ha detenido.
    pause
)

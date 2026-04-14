@echo off
set "SAFE_DIR=C:\Atlas_CR_Directo"

echo.
echo ========================================================
echo PREPARANDO APLICACION PARA BYPASS DE ONEDRIVE Y RUTAS
echo ========================================================
echo.

IF NOT EXIST "%SAFE_DIR%" (
   echo Creando carpeta segura en %SAFE_DIR% ...
   mkdir "%SAFE_DIR%"
   echo Copiando archivos para evitar errores de red y caracteres especiales...
   xcopy "%~dp0*.*" "%SAFE_DIR%\" /E /C /I /Y /Q > nul
) ELSE (
   echo Sincronizando cualquier cambio reciente a %SAFE_DIR% ...
   xcopy "%~dp0*.*" "%SAFE_DIR%\" /E /C /I /Y /Q /D > nul
)

:: Quitar Solo Lectura en destino
attrib -R "%SAFE_DIR%\*.*" /S /D

:: Cambiar al directorio seguro limpio de tildes o OneDrive
cd /d "%SAFE_DIR%"

:: Agregar excepcion a Flash
set "FLASH_TRUST=%APPDATA%\Macromedia\Flash Player\#Security\FlashPlayerTrust"
if not exist "%FLASH_TRUST%" mkdir "%FLASH_TRUST%"
echo %SAFE_DIR%> "%FLASH_TRUST%\atlas.cfg"

echo.
echo Ejecutando desde unidad C: raiz...
start "" "atlas.exe"
exit

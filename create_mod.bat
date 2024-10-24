@echo off
setlocal

rem Define the paths
set "INFO_JSON=info.json"
set "DATA_LUA=data.lua"
set "LOCALE_DIR=locale"
set "FACTORIO_MODS_DIR=%APPDATA%\Factorio\mods"  rem Change this if necessary

rem Check if info.json exists
if not exist "%INFO_JSON%" (
    echo Error: %INFO_JSON% not found!
    exit /b 1
)

rem Read name and version from info.json using PowerShell
for /f "delims=" %%i in ('powershell -command "Get-Content '%INFO_JSON%' | ConvertFrom-Json | Select-Object -ExpandProperty name"') do set "NAME=%%i"
for /f "delims=" %%i in ('powershell -command "Get-Content '%INFO_JSON%' | ConvertFrom-Json | Select-Object -ExpandProperty version"') do set "VERSION=%%i"

rem Check if name and version were found
if "%NAME%"=="" (
    echo Error: Could not extract name from %INFO_JSON%
    exit /b 1
)
if "%VERSION%"=="" (
    echo Error: Could not extract version from %INFO_JSON%
    exit /b 1
)

rem Create the name_version string
set "PACKAGE_NAME=%NAME%_%VERSION%"

rem Create the zip file
set "ZIP_FILE=%PACKAGE_NAME%.zip"
powershell -command "Compress-Archive -Path '%INFO_JSON%', '%DATA_LUA%', '%LOCALE_DIR%\*' -DestinationPath '%ZIP_FILE%'"

rem Check if the zip file was created successfully
if not exist "%ZIP_FILE%" (
    echo Error: Failed to create zip file %ZIP_FILE%
    exit /b 1
)

rem Copy the zip file to the Factorio mods directory
copy "%ZIP_FILE%" "%FACTORIO_MODS_DIR%"

del "%ZIP_FILE%"

rem Check if the copy was successful
if errorlevel 1 (
    echo Error: Failed to copy %ZIP_FILE% to %FACTORIO_MODS_DIR%
    exit /b 1
) else (
    echo Successfully created and copied %ZIP_FILE% to %FACTORIO_MODS_DIR%
)



endlocal

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

rem Create a temporary directory to hold the mod contents
set "TEMP_DIR=%TEMP%\%PACKAGE_NAME%"
mkdir "%TEMP_DIR%"
if errorlevel 1 (
    echo Error: Failed to create temporary directory %TEMP_DIR%
    exit /b 1
)

rem Create a directory for the package inside the temporary directory
mkdir "%TEMP_DIR%\%PACKAGE_NAME%"
if errorlevel 1 (
    echo Error: Failed to create package directory %TEMP_DIR%\%PACKAGE_NAME%
    exit /b 1
)

rem Copy the files into the package directory
copy "%INFO_JSON%" "%TEMP_DIR%\%PACKAGE_NAME%\"
copy "%DATA_LUA%" "%TEMP_DIR%\%PACKAGE_NAME%\"
copy "upgrade-overlay.png " "%TEMP_DIR%\%PACKAGE_NAME%\"
xcopy "%LOCALE_DIR%\*" "%TEMP_DIR%\%PACKAGE_NAME%\%LOCALE_DIR%\" /E /I /Y

rem Create the zip file
set "ZIP_FILE=%PACKAGE_NAME%.zip"
powershell -command "Compress-Archive -Path '%TEMP_DIR%\*' -DestinationPath '%ZIP_FILE%'"

rem Check if the zip file was created successfully
if not exist "%ZIP_FILE%" (
    echo Error: Failed to create zip file %ZIP_FILE%
    exit /b 1
)

rem Copy the zip file to the Factorio mods directory
copy "%ZIP_FILE%" "%FACTORIO_MODS_DIR%"

rem Check if the copy was successful
if errorlevel 1 (
    echo Error: Failed to copy %ZIP_FILE% to %FACTORIO_MODS_DIR%
    exit /b 1
) else (
    echo Successfully created and copied %ZIP_FILE% to %FACTORIO_MODS_DIR%
)

rem Remove the temporary zip file and directory
del "%ZIP_FILE%"
if errorlevel 1 (
    echo Error: Failed to delete temporary zip file %ZIP_FILE%
) else (
    echo Successfully deleted temporary zip file %ZIP_FILE%
)

rmdir /S /Q "%TEMP_DIR%"
if errorlevel 1 (
    echo Error: Failed to delete temporary directory %TEMP_DIR%
) else (
    echo Successfully deleted temporary directory %TEMP_DIR%
)

endlocal

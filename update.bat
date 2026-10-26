@echo off
chcp 65001 >nul
echo ===================================================
echo     TIEN TRINH TU DONG CAP NHAT AUTO JX1
echo ===================================================
echo Dang dong tien trinh Auto cu...
taskkill /f /im jx1offline.exe >nul 2>&1
taskkill /f /im KYKeoxe.exe >nul 2>&1
timeout /t 1 /nobreak >nul 2>&1

set TARGET_DIR=%~dp0
cd /d "%TARGET_DIR%"

echo Dang ghi de phien ban moi...

:: 1. TRUONG HOP GOI CAP NHAT LA FILE ZIP
if exist "%TARGET_DIR%update_package.zip" (
    echo Phat hien goi cap nhat ZIP, dang tu dong giai nen...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%TARGET_DIR%update_package.zip' -DestinationPath '%TARGET_DIR%' -Force" >nul 2>&1
    del /f /q "%TARGET_DIR%update_package.zip" >nul 2>&1
)

:: 2. TRUONG HOP GOI CAP NHAT LA FILE RAR CO MAT KHAU (VD: AutoJX1_pass_123456.rar)
for %%f in ("%TARGET_DIR%*.rar") do (
    echo Phat hien goi RAR: %%~nxf, dang giai nen bang UnRAR voi pass 123456...
    if exist "%TARGET_DIR%UnRAR.exe" (
        "%TARGET_DIR%UnRAR.exe" x -p123456 -y -o+ "%%f" "%TARGET_DIR%" >nul 2>&1
    ) else if exist "%ProgramFiles%\WinRAR\UnRAR.exe" (
        "%ProgramFiles%\WinRAR\UnRAR.exe" x -p123456 -y -o+ "%%f" "%TARGET_DIR%" >nul 2>&1
    ) else if exist "%ProgramFiles%\7-Zip\7z.exe" (
        "%ProgramFiles%\7-Zip\7z.exe" x "%%f" -p123456 -o"%TARGET_DIR%" -y >nul 2>&1
    )
)

:: 3. TRUONG HOP CAP NHAT LA FILE EXE TRUC TIEP
if exist "%TARGET_DIR%jx1offline_update.exe" (
    copy /y "%TARGET_DIR%jx1offline_update.exe" "%TARGET_DIR%jx1offline.exe" >nul
    del /f /q "%TARGET_DIR%jx1offline_update.exe" >nul 2>&1
)

if exist "%TARGET_DIR%bin\Release\jx1offline_update.exe" (
    copy /y "%TARGET_DIR%bin\Release\jx1offline_update.exe" "%TARGET_DIR%bin\Release\jx1offline.exe" >nul
    del /f /q "%TARGET_DIR%bin\Release\jx1offline_update.exe" >nul 2>&1
)

if exist "%TARGET_DIR%bin\Debug\jx1offline_update.exe" (
    copy /y "%TARGET_DIR%bin\Debug\jx1offline_update.exe" "%TARGET_DIR%bin\Debug\jx1offline.exe" >nul
    del /f /q "%TARGET_DIR%bin\Debug\jx1offline_update.exe" >nul 2>&1
)

echo Cap nhat hoan tat! Dang khoi dong Auto phien ban moi...
start "" "%TARGET_DIR%jx1offline.exe"
exit

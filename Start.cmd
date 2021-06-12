@echo off
CLS

REM Force run as Administrator
:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)

setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO args = "ELEV " >> "%temp%\OEgetPrivileges.vbs"
ECHO For Each strArg in WScript.Arguments >> "%temp%\OEgetPrivileges.vbs"
ECHO args = args ^& strArg ^& " "  >> "%temp%\OEgetPrivileges.vbs"
ECHO Next >> "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%SystemRoot%\System32\WScript.exe" "%temp%\OEgetPrivileges.vbs" %*
exit /B

:gotPrivileges
if '%1'=='ELEV' shift /1
setlocal & pushd .
cd /d %~dp0

echo Disabling Services
echo ==========================
call .\scripts\services.cmd
echo [Complete]
echo:

echo Performing Tweaks
echo ==========================
regedit.exe /S .\scripts\tweaks.reg
echo The following has been disabled:
echo - Promotional and unwanted apps that are installed without consent
echo - Suggested apps in the Start Menu
echo - Advertising in File Explorer
echo - Telemetry data collection
echo - Advertising ID used to show relevant adverts
echo - Cortana and her data collection
echo - Bing search in Start Menu
echo - Notifications of Windows tips, tricks and suggestions
echo - Windows Experience popup that appears after updates and from time to time
echo - Notifications asking for Windows feedback
echo - Windows Defender's automatic sample submission
echo - Location services
echo - 3D Objects folder
echo - People and Weather icon/menus on the taskbar
echo:
echo These changes have also been made:
echo - Windows Update will now only use peer to peer connections on the local network
echo:
echo [Complete]
echo:

echo Removing Default Apps
echo ==========================
echo This may take a few moments...
powershell -executionpolicy bypass -file ".\scripts\apps.ps1"
echo [Complete]

REM echo :
REM echo Uninstall OneDrive
REM echo ==========================
REM echo [Complete]
REM %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall

echo:
echo All tasks complete.
pause

@echo off

rem Main

rem.Authors: Ansh Singh 2021-  and Felix Wiegand 2016-2017

cls

echo.This program is free software: you can redistribute it and/or modify
echo.it under the terms of the GNU General Public License as published by
echo.the Free Software Foundation, either version 3 of the License, or
echo.(at your option) any later version.
echo.
echo.This program is distributed in the hope that it will be useful,
echo.but WITHOUT ANY WARRANTY; without even the implied warranty of
echo.MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
echo.GNU General Public License for more details.
echo.
echo.You should have received a copy of the GNU General Public License
echo.along with this program.  If not, see http://www.gnu.org/licenses/

echo.
echo.
echo.Service configuration
echo.
echo.Please select one of following options:
echo.To use Black Viper's Windows 10 Service Configuration 'Safe' press "s" and enter
echo.To use Microsoft's Windows 10 Service Configuration press enter (default)
setlocal
set /p ask=Please select (s/M)? || set ask=m
if /i %ask%==s (
	for /f %%h in (ServicesW10BVS.inf) do (call:disableService %%h)
)

echo.
echo.Following Services can be disabled...
echo.Press "y" and enter to disable this service.
echo.Press enter to do nothing.
for /f %%h in (ServicesW10Ask.inf) do (call:iaDisableService %%h)
endlocal

echo.
echo.
setlocal
set /p ask=Do you want to disable Cortana (y/N)? || set ask=n
if /i %ask%==y (
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
)
set /p ask=Do you want to disable Windows Defender (y/N)? || set ask=n
if /i %ask%==y (
	reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f
)
endlocal

echo.
echo.
echo.Windows apps configuration
echo.Press "y" and enter to delete...
echo.Press enter to do nothing.
echo.Running DISM.EXE
echo.Please wait...
setlocal
for /f "tokens=1,2 delims=:" %%i in ('dism /online /Get-ProvisionedAppxPackages') do (call:setupWindowsApps %%i %%j)
endlocal

echo.
echo.
echo.Data collection tasks will be disabled...
setlocal
for /f "eol=; tokens=*" %%i in (SchTasksW10.inf) do (call:rmTasks %%i)
endlocal

echo.
echo.Disabling more data logging services
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl

echo.
echo Removing all folders from MyPC
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f > NUL 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f > NUL 2>&1
echo.

rem Windows Privacy Tweaker 2.0
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d Off /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v SystemSettingsDownloadMode /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowFullControl /t REG_DWORD /d 0 /f

rem Lockscreen tweak
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f

echo.
echo.Please make sure you do the following as well:
echo.Head to Settings - Privacy, and disable everything, unless there are some things you really need.
echo.While within the Privacy page, go to Diagnostics & feedback, select Never in the last box, and Basic in the second box

rem End Main
goto:eof

rem Functions

:setupSystemApps
call:formatPkgName result %1
if /i %result%==WindowsFeedback (
	rmdir /s /q "%sysAppsRoot%\%1"
	goto:eof
)
find /i "%result%" SystemApps.inf >nul
if errorlevel 1 goto:rmSystemApp
goto:eof

:rmSystemApp
set /p ask=Do you want to delete this system app "%result%" (y/N)? || set ask=n
if /i not %ask%==y goto:eof
rmdir /s /q "%sysAppsRoot%\%1"
goto:eof

:rmTasks
if [%1]==[] goto:eof
schtasks /end /tn %1
schtasks /change /disable /tn %1
goto:eof

:iaDisableService
if [%1]==[] goto:eof
echo.
sc qdescription %1 1024 
set /p ask=Turn off this service (y/N) || set ask=n
if /i not %ask%==y goto:eof
:disableService
if [%1]==[] goto:eof
sc stop %1 >nul
sc config %1 start= disabled
goto:eof

:setupWindowsApps
if /i not %1==PackageName goto:eof
call:formatPkgName result %2
find /i "%result%" WindowsApps.inf >nul
if errorlevel 1 goto:rmWindowsApp
goto:eof

:rmWindowsApp
set /p ask=Do you want to delete this app "%result%" (y/N)? || set ask=n
if /i not %ask%==y goto:eof
dism /Online /Remove-ProvisionedAppxPackage /PackageName:%2
goto:eof

:formatPkgName
set _test=%2
set _endbit=%_test:*_=%
call set _result=%%_test:%_endbit%=%%
set %1=%_result:~0,-1%
goto:eof

rem End

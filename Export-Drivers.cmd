REM This script will export out-of-box drivers to C:\Drivers
REM This script will also provide a folder name to use where you should save drivers to a share
REM This folder name cannot contain some characters and thus may not be valid for all systems
REM Example: You cannot name a folder with the slash characters "/" or "\"
MD C:\Drivers
DISM /Online /Export-driver /Destination:C:\Drivers
@ECHO Off
ECHO Save C:\Drivers to a share on the network. 
ECHO The folder name where you save drivers should be named as follows;
for /f "tokens=2 delims==" %%I in ('wmic computersystem get Manufacturer /format:list') do set "SYSMANUFACTURER=%%I"
for /f "tokens=2 delims==" %%I in ('wmic computersystem get model /format:list') do set "SYSMODEL=%%I"
for /f "tokens=2 delims== " %%b in ('set processor ^|find "PROCESSOR_ARCHITECTURE="') do set "OSArch=%%b"

@ECHO.
@ECHO .\Drivers\%SYSMANUFACTURER%\%SYSMODEL%\%OSArch%
@ECHO.

CALL :TRIM %SYSMANUFACTURER%
SET SYSMANUFACTURER=%TRIMRESULT%

CALL :TRIM %SYSMODEL%
SET SYSMODEL=%TRIMRESULT%

GOTO END

:TRIM
SET TRIMRESULT=%*
IF "%TRIMRESULT:~-1%"=="." SET TRIMRESULT=%TRIMRESULT:~,-1%
GOTO :eof
:END
MD C:\Drivers
DISM /Online /Export-drivers /Destination:C:\Drivers
​
@ECHO Off
ECHO Save C:\Drivers to a share on the network. 
ECHO The folder name where you save drivers should be named as follows;

for /f "tokens=2 delims==" %%I in ('wmic computersystem get Manufacturer /format:list') do set "SYSMANUFACTURER=%%I"
for /f "tokens=2 delims==" %%I in ('wmic computersystem get model /format:list') do set "SYSMODEL=%%I"
for /f "tokens=2 delims== " %%b in ('set processor ^|find "PROCESSOR_ARCHITECTURE="') do set "OSArch=%%b"
​
CALL :TRIM %SYSMANUFACTURER%
SET SYSMANUFACTURER=%TRIMRESULT%
​
CALL :TRIM %SYSMODEL%
SET SYSMODEL=%TRIMRESULT%
​
GOTO END
​
:TRIM
SET TRIMRESULT=%*
IF "%TRIMRESULT:~-1%"=="." SET TRIMRESULT=%TRIMRESULT:~,-1%
GOTO :eof
:END
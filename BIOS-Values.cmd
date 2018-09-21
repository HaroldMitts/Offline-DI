@ECHO Off
FOR /f "tokens=2 delims==" %%I IN ('wmic computersystem get Manufacturer /format:list') DO SET "SYSMANUFACTURER=%%I"
FOR /f "tokens=2 delims==" %%I IN ('wmic computersystem get model /format:list') DO SET "SYSMODEL=%%I"
FOR /f "tokens=2 delims== " %%b IN ('set processor ^|find "PROCESSOR_ARCHITECTURE="') DO SET "OSArch=%%b"

CALL :TRIM %SYSMANUFACTURER%
SET SYSMANUFACTURER=%TRIMRESULT%

CALL :TRIM %SYSMODEL%
SET SYSMODEL=%TRIMRESULT%

@ECHO.
@ECHO This computersystem is a %SYSMANUFACTURER% %SYSMODEL% 
@ECHO Save the drivers from C:\Drivers to a folder in your storage named exactly as shown:
@ECHO.
@ECHO %DRV%\Drivers\%SYSMANUFACTURER%\%SYSMODEL%\%OSARCH%

GOTO END

:TRIM
SET TRIMRESULT=%*
IF "%TRIMRESULT:~-1%"=="." SET TRIMRESULT=%TRIMRESULT:~,-1%
GOTO :eof
:END

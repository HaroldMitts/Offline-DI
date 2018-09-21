@ECHO off
FOR /f "tokens=2 delims==" %%I IN ('wmic computersystem get Manufacturer /format:list') DO SET "SYSMANUFACTURER=%%I"
FOR /f "tokens=2 delims==" %%I IN ('wmic computersystem get model /format:list') DO SET "SYSMODEL=%%I"
rem FOR %%a IN (c d e f g h i j k l m n o p q r s t u v w x y z) DO VOL %%a: 2>NUL|find "USB-B" >NUL && SET DRV=%%a:

CALL :TRIM %SYSMANUFACTURER%
SET SYSMANUFACTURER=%TRIMRESULT%

CALL :TRIM %SYSMODEL%
SET SYSMODEL=%TRIMRESULT%

FOR /f "tokens=2 delims== " %%b IN ('set processor ^|find "PROCESSOR_ARCHITECTURE="') DO SET "OSArch=%%b"


SET DRV="Z:\USB-B\Deployment"
@ECHO Setting Drivers root ( %DRV% ) to Z: 
@ECHO Deploying Drivers for %SYSMANUFACTURER% %SYSMODEL% %OSARCH% using the following path;
@ECHO %DRV%\Drivers\%SYSMANUFACTURER%\%SYSMODEL%\%OSARCH%

IF EXIST "%DRV%\Drivers\%SYSMANUFACTURER%\%SYSMODEL%\%OSARCH%" (
         DISM /Image:W:\ /Add-Driver /Driver:"%DRV%\Drivers\%SYSMANUFACTURER%\%SYSMODEL%\%OSARCH%" /Recurse
          ) ELSE (
                   COLOR c0
                   @ECHO ATTENTION: No Drivers found for this Manufacturer/Model
                   @ECHO Make sure drivers are saved to this path %DRV%\Drivers\%SYSMANUFACTURER%\%SYSMODEL%\%OSARCH%\
                   @ECHO.
                   @ECHO Press any key to proceed
                   PAUSE > NUL
                 )

GOTO END

:TRIM
SET TRIMRESULT=%*
IF "%TRIMRESULT:~-1%"=="." SET TRIMRESULT=%TRIMRESULT:~,-1%
GOTO :eof
:END
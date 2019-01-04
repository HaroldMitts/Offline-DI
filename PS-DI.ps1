<# This script will check the WMI to get the PC manufacturer, PC model, and OS architecture
and then will attempt to find network folder paths named after the values stored in the devices WMI. 
If matching folders are found, DISM will install drivers to the offline installation. 

This script should be run after Windows installation completes, but while the device is still booted 
to WinPE. 

Network share where drivers are saved is assumed to be Z:\Drivers

Prerequisite: You must add the PowerShell optional component to WinPE for WinPE to support this script
OC install order: 
1. WinPE-WMI.cab
2. WinPE-WMI_en-us.cab
3. WinPE-Scripting.cab
4. WinPE-Scripting_en-us.cab 
5. WinPE-NetFx.cab
6. WinPE-NetFx_en-us.cab
7. WinPE-Scripting_en-us.cab
8. WinPE-PowerShell.cab
9. WinPE-PowerShell_en-us.cab

Place your INF drivers into folders named after WMI values. 
Example:  D:\Drivers\Microsoft Corporation\Virtual Machine\64-bit
Caution: DISM /Recurse will install all drivers found in the folder. For this reason, only drivers 
which match the device should be saved to this location. This will help avoid loading unnecessary drivers.
#>

$SysManufacturer = (Get-WmiObject -Class:Win32_ComputerSystem).Manufacturer
$SysModel = (Get-WmiObject -Class:Win32_ComputerSystem).Model
$OSArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

Write-Output "Deploying drivers based on the following device variables"
Write-Output ""
Write-Output "PC Manufacturer: $SysManufacturer"
Write-Output "PC Model: $SysModel"
Write-Output "OS Architecture: $OSArch"

if (Test-Path Z:\Drivers\$sysmanufacturer -PathType Container) 
	{
		if (Test-Path Z:\Drivers\$SysManufacturer\$SysModel -PathType Container)
			{
				if (Test-Path Z:\Drivers\$SysManufacturer\$SysModel\$OSArch)
					{
						
					}
	Dism.exe /Image:W:\ /Add-Driver /Driver:"Z:\Drivers\$SysManufacturer\$SysModel\$OSArch" /Recurse
			}
	} Else { Write-Output "Path Does Not Exist - Check that drivers exist in a subfolder at Z:\Drivers\$SysManufacturer\$SysModel\$OSArch" }
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
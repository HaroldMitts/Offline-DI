# Offline Driver Injection
The scripts in this repository can help you to deploy device drivers to an offline Windows installation while the device is booted to Windows PE.

## Overview
Many methods of installing drivers exist, however, most will require you to specify which driver to install. This is fine if you are deploying to the same model of PC, over and over. But what if you have to install to a wide variety of hardware? Either you have to build the device drivers in to many different images or install them at deployment time manually. 

This simple solution will enable you to dynamically inject device drivers into an offline Windows installation, based on device manufacturer and model values which are written into the device firmware (BIOS or UEFI).

To accomplish this, simply collect all of the required device drivers for a particular model of PC you need to image, and stage them in a folder which is named after the device manufacturer and model values, as written to the firmware. This way, you can deploy a 'generic image' - one which does not contain out-of-box device drivers, and dynamically query and inject device drivers at deployment time by performing a lookup for these manufacturer and model values and then injecting the drivers saved to the staged folder containing those drivers.

The main action part of the script is leveraging the DISM (Deployment Image Servicing and Management) command after checking that a path exists which matches the firmware values for the device. DISM is part of Windows PE and included in the Windows ADK. The Windows ADK is not required however, since DISM is built into every version of Windows 10. 

The process flow for offline driver injection is described in 2 steps;

* ***Preproduction Phase***: where machine info is discovered and drivers are staged to a folder

* ***Production Use***: where staged drivers are injected into a device installation, during Windows PE, as follows;

### Preproduction phase

1. Determine the firmware (BIOS or UEFI) values set in the device for manufacturer, model, and the value in the OS for processor architecture. Use the BIOS-Values.cmd script to determine these values, while the PC is booted to Windows. You can also run this script under Windows PE, but the Windows PE will require optional components for WMI (See Microsoft documentation for details on adding optional components to Windows PE at this link [WinPE Optional Component Step-by-step](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference)).

2. Create a folder named after the values found in step 1. The drivers must be saved to this location, in **INF format**.

3. Obtain the device drivers which match the device and copy them to the folder amd64 folder (for 64-bit) or x86 (for 32-bit). These drivers must be in INF format. Executable device drivers will not be injected and are unsupported by DISM.

### Production use

1. Deploy Windows to a device, using Windows PE or a script run during Windows PE.

> Microsoft maintains a great script called **walkthough-deploy.bat** and it can be run during Windows PE to deploy Windows to devices, including BIOS and EUFI methods and hard disk recovery. You can download it in the USB-B sample here: https://download.microsoft.com/download/5/8/4/5844EE21-4EF5-45B7-8D36-31619017B76A/USB-B.zip - the walkthrough-deploy.bat and its associated files are located in the Deployment subfolder of the download).

2. With the device still booted to Windows PE, and after Windows has been applied to the disk, the drive letters should have temporary letters assigned to them. 

* System Drive = **S**
* Windows Drive = **W**
* Recovery Driver = **R**

_(UEFI systems will contain additional partitions for MSR and EFI)_

3. While still in Windows PE, connect to the network share where you staged drivers in the preproduction phase, or connect the USB drive (if not using the network method). You can use the **NET USE** command. 

4. Run the **offline-di.cmd** script which matches your deployment method (OfflineDI-Net.cmd for network or OfflineDI-USB for USB method) and verify the script successfully connected to the staging folder and injected any drivers found (You will verify they successfully installed during OOBE). 

5. Type **Exit**, in the Windows PE command prompt, to reboot the computer

6. The device should boot to OOBE. Press **Shift + F10** keys to bring up a command prompt. 

7. Type **devmgmt.msc** to invoke Device Manager and verify all device drivers are supported. If you still have devices which are unsupported, you should troubleshoot this and retry the deployment and driver injection. Some causes for missed drivers can include; 

* Missing drivers in the staged driver location
* Missing firmware values for manufacturer or model (in this case, you must manage device drivers using a different method)
* Improper driver staging (check to be sure you put the drivers into the right location)
* Drivers added to staging do not match the devices present 

8. Shutdown the device using the Shutdown command. Example; **SHUTDOWN -T 0**

9. Prepare the device for shipment. Put it into inventory, ship it, or deliver it to the end-user.

# Offline Driver Injection
The scripts in this repository can help you to deploy device drivers to an offline Windows installation while the device is booted to Windows PE.

Many methods of installing drivers exist, however, most will require you to specify which driver to install. This is fine if you are deploying to the same model of PC, over and over. But what if you have to install to a wide variety of hardware? Either you have to build the device drivers in to many different images or install them at deployment time manually. 

This simple solution will enable you to dynamically inject device drivers into an offline Windows installation, based on device manufacturer and model values which are written into the device firmware (BIOS or UEFI).

To accomplish this, simply collect all of the required device drivers for a particular model of PC you need to image, and stage them in a folder which is named after the device manufacturer and model values, as written to the firmware. This way, you can deploy a 'generic image' - one which does not contain out-of-box device drivers, and dynamically query and inject device drivers at deployment time by performing a lookup for these manufacturer and model values and then injecting the drivers saved to the staged folder containing those drivers.

The main action part of the script is leveraging the DISM command after checking for existing path which matches the firmware values.



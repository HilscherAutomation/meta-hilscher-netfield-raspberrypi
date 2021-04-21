
#undef CONFIG_BOOTCOMMAND
#define CONFIG_BOOTCOMMAND "run bootcmd_usb0; run bootcmd_mmc0;"
#define CONFIG_SYS_BOOTM_LEN 0x1000000

#ifndef DEBUG_TWEAKS
	#undef CONFIG_BOOTDELAY
	#define CONFIG_BOOTDELAY -2
	#undef ENV_DEVICE_SETTINGS
	#define ENV_DEVICE_SETTINGS \
		"stdin=serial,usbkbd\0" \
		"stdout=vidconsole\0" \
		"stderr=vidconsole\0"
#else
	#undef CONFIG_BOOTDELAY
	#define CONFIG_BOOTDELAY 5
	#undef ENV_DEVICE_SETTINGS
	#define ENV_DEVICE_SETTINGS \
	        "stdin=serial,usbkbd\0" \
	        "stdout=serial,vidconsole\0" \
	        "stderr=serial,vidconsole\0"
#endif

#undef CONFIG_EXTRA_ENV_SETTINGS
#define CONFIG_EXTRA_ENV_SETTINGS \
        "dhcpuboot=usb start; dhcp u-boot.uimg; bootm\0" \
        ENV_DEVICE_SETTINGS \
        ENV_MEM_LAYOUT_SETTINGS \
        BOOTENV

#ifdef CONFIG_SYS_MAXARGS
#undef CONFIG_SYS_MAXARGS
#endif
#define CONFIG_SYS_MAXARGS 64

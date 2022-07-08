/* config of rpi */

/* default is 4 which lead to connection trouble (dhcp/bootp) in some network setups */
#ifdef CONFIG_BOOTP_ID_CACHE_SIZE
	#undef CONFIG_BOOTP_ID_CACHE_SIZE
	#define CONFIG_BOOTP_ID_CACHE_SIZE 10
#endif

#ifdef CONFIG_LOADADDR
	#undef CONFIG_LOADADDR
	#define CONFIG_LOADADDR      0x20000000
#endif

#ifdef CONFIG_SYS_LOAD_ADDR
	#undef CONFIG_SYS_LOAD_ADDR
	#define CONFIG_SYS_LOAD_ADDR CONFIG_LOADADDR
#endif

/* Platform specific initialization */
//  Note:
//    Since the MSDOS partition table does not contain the partition labels,
//    these will be hard configured int the platform_init script.
//
//    When the platform switch to GPT partition table, the code below can be used to obtain the partition numbers.
//      "part number $plat_dev_if $plat_dev boot plat_boot_part; " \
//      "part number $plat_dev_if $plat_dev system plat_system_part; " \
//      "part number $usb_dev_if $usb_dev recovery usb_recovery_part; "
#define PLATFORM_INIT \
	"fdt addr $fdt_addr && fdt get value basebootargs /chosen bootargs; " \
	"setenv basebootargs $basebootargs firmware_class.path=/usr/local/lib/firmware rootflags=noatime overlayflags=noatime ro rootwait loglevel=4; " \
	"setenv plat_boot_part 1; " \
	"setenv plat_system_part 3; " \
	"usb reset; " \
	"setenv usb_recovery_part 1; "

/* definition not necesarry since control is done via keyboard, screen, serial... */
#define BOARD_CONFIG_EXTRA_ENV_SETTINGS \
	"basebootargs=dummy - see platform_init\0" \
	"plat_dev_if=mmc\0" \
	"plat_dev=0\0" \
	"plat_dev_linux=/dev/mmcblk0p\0" \
	"usb_dev_if=usb\0" \
	"usb_dev=0\0" \
	"fdtfile=bcm2837-rpi-3-b.dtb\0 " \

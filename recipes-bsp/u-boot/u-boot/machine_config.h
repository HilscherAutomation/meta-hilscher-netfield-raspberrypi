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

/* just dump hab status at the beginning */
#define PLATFORM_INIT \
	" "

/* definition not necesarry since control is done via keyboard, screen, serial... */
#define BOARD_CONFIG_EXTRA_ENV_SETTINGS \
	"fdtfile=bcm2837-rpi-3-b.dtb\0 " \
	"mmc_parts=1\0 " \
	"\0"


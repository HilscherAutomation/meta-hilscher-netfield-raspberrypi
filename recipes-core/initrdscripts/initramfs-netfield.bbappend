FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

# Required by *platform_init*
RDEPENDS_${PN}-platform-init_append += "kernel-module-smsc95xx kernel-module-usbnet"

# Required by *detect_cifx*
RDEPENDS_${PN}-detect-cifx_append += "kernel-module-spi-bcm2835 kernel-module-spi-bcm2835aux"

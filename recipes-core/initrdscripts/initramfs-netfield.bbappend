FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# Required by *platform_init*
RDEPENDS:${PN}-platform-init:append = " kernel-module-smsc95xx kernel-module-usbnet"

# Required by *detect_cifx*
RDEPENDS:${PN}-detect-cifx:append = " kernel-module-spi-bcm2835 kernel-module-spi-bcm2835aux"

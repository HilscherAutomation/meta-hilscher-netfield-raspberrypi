FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://boot-2.3-recovery.cmd"

BOOT_SCRIPTS:append = " boot-2.3-recovery.cmd"

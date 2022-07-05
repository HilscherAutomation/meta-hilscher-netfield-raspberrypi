FILESEXTRAPATHS_append := "${THISDIR}/boot-script-fit"

SRC_URI_append += "file://boot-update.cmd"
SRC_URI_append += "file://boot-scan.cmd"
SRC_URI_append += "file://boot-pxe.cmd"

BOOT_SCRIPTS += "boot-update.cmd boot-scan.cmd boot-pxe.cmd"

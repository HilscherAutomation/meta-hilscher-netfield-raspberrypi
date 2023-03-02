FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append += "file://boot-2.3-recovery.cmd"

BOOT_SCRIPTS_append += "boot-2.3-recovery.cmd"

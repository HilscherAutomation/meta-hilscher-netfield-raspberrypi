FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

RDEPENDS_${PN}_append += "kernel-module-smsc95xx kernel-module-usbnet"

FILES_${PN}_append += "/"

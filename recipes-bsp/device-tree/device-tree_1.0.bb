SUMMARY = "Hilscher BSP device trees"
DESCRIPTION = "Hilscher BSP device trees from within layer."
SECTION = "bsp"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://rpi-mmc-firmware-overlay.dtso"

COMPATIBLE_MACHINE:niot-e-tpi51-en-re = ".*"

inherit devicetree

S = "${WORKDIR}"

devicetree_do_install:append() {
	default_dtb="${KERNEL_DEVICETREE}"
	[ -z "$default_dtb" ] && default_dtb="${MACHINE}.dtb"
	install -d ${D}/boot/dt-overlays
	for DTB_FILE in `ls *.dtbo`; do
		mv ${D}/boot/devicetree/${DTB_FILE} ${D}/boot/dt-overlays
	done

	rm -r ${D}/boot/devicetree
}

devicetree_do_deploy() {
	cp -a ${D}/boot/* ${DEPLOYDIR}
}

FILES:${PN} += "boot/dt-overlays/*"

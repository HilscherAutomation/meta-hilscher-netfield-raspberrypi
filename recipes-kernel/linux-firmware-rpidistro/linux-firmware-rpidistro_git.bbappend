FILESEXTRAPATHS_append := "${THISDIR}/files:"

SRC_URI_append += "file://brcmfmac43430-sdio.raspberrypi,3-model-b.txt"

do_install_append() {
	mkdir -p ${D}/${nonarch_base_libdir}/firmware/brcm
	install -m 0644 $_firmware ${WORKDIR}/brcmfmac43430-sdio.raspberrypi,3-model-b.txt ${D}${nonarch_base_libdir}/firmware/brcm
}

FILES_${PN}-bcm43430 += " \
	${nonarch_base_libdir}/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.txt \
"

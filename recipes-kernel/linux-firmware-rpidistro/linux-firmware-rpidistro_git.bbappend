do_install:append() {
    ln -s brcmfmac43430-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.bin
}

FILES:${PN}-bcm43430 += " \
    ${nonarch_base_libdir}/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.bin \
"

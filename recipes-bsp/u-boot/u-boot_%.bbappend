FILESEXTRAPATHS_append := "${THISDIR}/files:"

RDEPENDS_${PN}_append += " boot-script-fit "
RDEPENDS_${PN}_remove += " rpi-u-boot-scr"

SRC_URI_append += "file://netpi_defconfig"
SRC_URI_append += "\
                   file://0002-added-netpi-configuration-header-allows-overriding-c.patch \
                   file://0003-add-support-for-FIT-script-boot.patch \
                   file://netpi.h \
                   file://fat_show_files_without_arch_attr.patch \
                   file://pxe_add_bootargs_append_func.patch"


SRC_URI_append += "file://disable_uart.patch"

UBOOT_MACHINE = "netpi_defconfig"

RPI_BOOTIMAGE_NAME ?= "kernel7.img"

#default device tree u-boot will use
UBOOT_DEVICE_TREE="bcm2837-rpi-3-b"

inherit dts-sign
#variables required to patch public key into dts
DTS_SIGN_ENFORCE="${PLATFORM_SIGN}"
DTS_SIGN_KEY_DIR="${PLATFORM_KEYDIR}"
DTS_SIGN_KEY_NAME="${PLATFORM_KEYNAME}"
DTS_TO_SIGN="${S}/arch/arm/dts/${UBOOT_DEVICE_TREE}.dts"

do_configure_prepend() {
    sed -i "s/CONFIG_DEFAULT_DEVICE_TREE=.*/CONFIG_DEFAULT_DEVICE_TREE=\"${UBOOT_DEVICE_TREE}\"/g" ${WORKDIR}/netpi_defconfig
    cp ${WORKDIR}/netpi_defconfig ${S}/configs/

    if ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'true', 'false', d)}; then
        echo "#define DEBUG_TWEAKS 1" > ${S}/include/configs/netpi.h
    fi
    cat ${WORKDIR}/netpi.h >> ${S}/include/configs/netpi.h
}

do_install_append() {
    rm -r ${D}/boot/*
    install -m 0644 ${B}/u-boot.bin ${D}/boot/${RPI_BOOTIMAGE_NAME}
}

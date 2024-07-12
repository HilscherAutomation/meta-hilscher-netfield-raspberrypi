FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require recipes-bsp/u-boot/u-boot-netfield.inc

DEPENDS:append = " u-boot-tools-native"

DEPENDS:${PN}:remove = "rpi-u-boot-scr"

SRC_URI:append = " file://netpi_defconfig \
                   file://machine_config.h \
                   file://0003-add-support-for-FIT-script-boot.patch \
                   file://Changed-config-file-from-machine-to-distro-specific-.patch \
                   file://fix-boot-script-issues-related-to-unit-addressing.patch"
#                   file://pxe_add_bootargs_append_func.patch \
#                   file://fix_console_handling.patch"

SRC_URI:append = " file://disable_uart.patch"

UBOOT_MACHINE = "netpi_defconfig"

RPI_BOOTIMAGE_NAME ?= "kernel7.img"

#default device tree u-boot will use
UBOOT_DEVICE_TREE = "bcm2837-rpi-3-b"

inherit dts-sign
#variables required to patch public key into dts
DTS_SIGN_ENFORCE="${PLATFORM_SIGN}"
DTS_SIGN_KEY_DIR="${PLATFORM_KEYDIR}"
DTS_SIGN_KEY_NAME="${PLATFORM_KEYNAME}"
DTS_TO_SIGN="${S}/arch/arm/dts/${UBOOT_DEVICE_TREE}.dts"

do_configure:prepend() {
    sed -i "s/CONFIG_DEFAULT_DEVICE_TREE=.*/CONFIG_DEFAULT_DEVICE_TREE=\"${UBOOT_DEVICE_TREE}\"/g" ${WORKDIR}/netpi_defconfig
    cp ${WORKDIR}/netpi_defconfig ${S}/configs/

    if ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'true', 'false', d)}; then
        echo "#define DEBUG_TWEAKS 1" > ${S}/include/configs/netpi.h
    fi
    cp ${WORKDIR}/machine_config.h ${S}/include/configs/
}

do_install:append() {
    rm -r ${D}/boot/*
    install -m 0644 ${B}/u-boot.bin ${D}/boot/${RPI_BOOTIMAGE_NAME}
}

SIGNED_TREE = "${B}/arch/arm/dts/${UBOOT_DEVICE_TREE}.dtb"

do_deploy:append() {
    # Copy this device tree to deploy directory.
    # This tree contains the public key which is required in the signature verification step of the fitimage.
    mkdir -p ${DEPLOYDIR}/devicetree/
    cp ${SIGNED_TREE} ${DEPLOYDIR}/devicetree/pub_key.dtb
}

inherit hilscher-deploy

hd_path = "${HDEPLOY_PATH_EXTRAS}/bootloader"

do_hilscher_deploy() {
	cp -a ${DEPLOYDIR}/$(readlink ${DEPLOYDIR}/u-boot.bin) ${hd_path}/
}
do_hilscher_deploy[cleandirs] = "${hd_path}/"
addtask hilscher_deploy before do_build after do_deploy

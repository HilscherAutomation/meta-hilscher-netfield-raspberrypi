SUMMARY = "FIT formatted shell files for u-boot verified boot"
DESCRIPTION = "FIT formatted shell files for u-boot verified boot"
LICENSE = "CLOSED"

DEPENDS = "u-boot u-boot-mkimage-native dtc-native"

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILESEXTRAPATHS_append := "${THISDIR}/boot-scripts"

SRC_URI_append += "file://boot.cmd"
SRC_URI_append += "file://boot-recovery.cmd"
SRC_URI_append += "file://boot-update.cmd"
SRC_URI_append += "file://boot-scan.cmd"
SRC_URI_append += "file://boot-pxe.cmd"

BOOT_SCRIPTS = "../boot.cmd ../boot-recovery.cmd ../boot-update.cmd ../boot-scan.cmd ../boot-pxe.cmd"

inherit boot-script-fitimage

# Make sure scripts are re-fetched if config changes to allow patching
do_fetch[vardeps] = "NETIOT_ROOT_OVERLAY NETIOT_OVERLAY_DIRS"
do_compile_prepend() {
    if [ "${NETIOT_ROOT_OVERLAY}" = "1" ]; then
        sed -i -e "s;@OVERLAYS@;overlay_root;g" ${WORKDIR}/boot.cmd
    else
        overlay_entry=$(echo ${NETIOT_OVERLAY_DIRS} | tr " " ",")
        sed -i -e "s;@OVERLAYS@;overlays=${overlay_entry};g" ${WORKDIR}/boot.cmd
    fi

    if ${@bb.utils.contains('EXTRA_IMAGE_FEATURES', 'debug-tweaks', 'true', 'false', d)}; then
        sed -e 's/loglevel=\[0-9\]/loglevel=7/' ${WORKDIR}/boot.cmd
    else
        sed -e 's/loglevel=\[0-9\]/loglevel=4/' ${WORKDIR}/boot.cmd
    fi
}

do_install_append() {
    install -d ${D}/boot
    install -m 0644 ${B}/boot-*fit ${D}/boot/
}

inherit deploy

do_deploy[vardepsexclude] += "DATETIME"
do_deploy() {
    # Update deploy directory
    if echo ${KERNEL_IMAGETYPES} | grep -wq "fitImage"; then
        install -d ${DEPLOYDIR}/${PN}
        cd ${B}
        for BOOT_SCRIPT in ${BOOT_SCRIPTS}; do
            install -m 0644 $(basename "${BOOT_SCRIPT%.cmd}-fit") ${DEPLOYDIR}/${PN}
        done
    fi
}
addtask deploy before do_build after do_install
do_deploy[dirs] += "${DEPLOYDIR}/${PN}"

FILES_${PN} = "/boot/"

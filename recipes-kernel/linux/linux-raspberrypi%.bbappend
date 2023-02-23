require recipes-kernel/linux/netfield-linux.inc

KBUILD_DEFCONFIG ?= "bcm2709_defconfig"

KMETA = "kernel-meta"
KCONF_BSP_AUDIT_LEVEL = "2"
LINUX_BASEVERSION="${@".".join(d.getVar('LINUX_VERSION', d).split(".")[:2])}"
do_fetch[vardeps] += "LINUX_BASEVERSION"
SRC_URI_append += "git://git.yoctoproject.org/git/yocto-kernel-cache;type=kmeta;name=meta;branch=yocto-${LINUX_BASEVERSION};destsuffix=${KMETA};protocol=https"
SRC_URI_append += "file://enable_bluetooth.cfg"
KERNEL_FEATURES_append += "features/bluetooth/bluetooth.scc"
KERNEL_FEATURES_append += "features/media/media.scc features/media/media-usb-webcams.scc"

UBOOT_RD_LOADADDRESS = "0x0A000000"
UBOOT_RD_ENTRYPOINT  = "0x0A000000"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CMDLINE = "dwc_otg.lpm_enable=0 console=tty1 logo.nologo dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0"

# DTS files
SRC_URI_append += "file://led-gpio.patch"

# Patches
SRC_URI_append += "file://0001-Added-initial-nxpi-overlays.patch \
                   file://0001-change-led0-to-heartbeat-trigger-instead-mmc.patch \
                   file://0001-device-tree-fix-uart-and-aux-spi-interrupt-config.patch"

# Kernel config
SRC_URI_append += "file://enable_cfg80211_wireless_compat_ext.cfg \
                   file://enable_i2c_chardev.cfg \
                   file://enable_led_trigger.cfg \
                   file://enable_nvram.cfg \
                   file://enable_overlayfs.cfg \
                   file://enable_rtc.cfg \
                   file://enable_sound.cfg \
                   file://enable_wlan.cfg \
                   file://fix_power_led_trigger.cfg \
                   file://ftdi_serial.cfg \
                   file://rtl8152.cfg \
                   file://use_performance_governor.cfg"

do_compile_append() {
        for DTB in ${RPI_KERNEL_DEVICETREE_OVERLAYS}; do
                DTB=`normalize_dtb "${DTB}"`
                oe_runmake ${DTB}

                # Add verification information to dtb
                if [ "${UBOOT_SIGN_ENABLE}" = "1" ]; then
                    if echo ${DTB} | grep -e ".dtb$"; then
                       cat <<EOF>dummy.its
/dts-v1/;

/ {

    description = "U-Boot fitImage for netIOT Edge/4.9.80+gitAUTOINC+9aed9998ad_machine/niot-e-tpi51-en-re";
    #address-cells = <1>;

    images {
        kernel@1 {
            data = <0>;
            hash@1 {
                    algo = "sha256";
            };
        };
    };

    configurations {
            default = "conf@1";
            conf@1 {
                    description = "dummy";
                    kernel = "kernel@1";
                    hash@1 {
                        algo = "sha256";
                    };

                    signature@1 {
                            algo = "${FIT_HASH_ALG},${FIT_SIGN_ALG}";
                            key-name-hint = "${UBOOT_SIGN_KEYNAME}";
                            sign-images = "kernel";
                    };
            };
    };
};
EOF
                        uboot-mkimage \
                            ${@'-D "${UBOOT_MKIMAGE_DTCOPTS}"' if len('${UBOOT_MKIMAGE_DTCOPTS}') else ''} \
                            -k "${UBOOT_SIGN_KEYDIR}" \
                            -K ${B}/arch/${ARCH}/boot/dts/${DTB} \
                            -r \
                            -f dummy.its dummy.itb
                        rm dummy.its dummy.itb
                    fi
                fi
        done
}

do_deploy_append() {
        for DTB in ${RPI_KERNEL_DEVICETREE_OVERLAYS}; do
                DTB=`normalize_dtb "${DTB}"`
                DTB_EXT=${DTB##*.}
                DTB_BASE_NAME=`basename ${DTB} ."${DTB_EXT}"`
                for type in ${KERNEL_IMAGETYPE_FOR_MAKE}; do
                        base_name=${DTB_BASE_NAME}
                        DTB_NAME=`echo ${base_name} | sed "s/${MACHINE}/${DTB_BASE_NAME}/g"`
                        DTB_PATH=`get_real_dtb_path_in_kernel "${DTB}"`
                        install -d ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/overlays
                        install -m 0644 ${DTB_PATH} ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/overlays/${DTB_NAME}.${DTB_EXT}
                done
        done
}

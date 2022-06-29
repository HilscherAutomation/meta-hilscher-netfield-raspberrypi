IMAGE_INSTALL_append += "libcifx-plugin-spm cifxtun eepromutils"

IMAGE_INSTALL_append += "linux-firmware-rpidistro-bcm43430 \
                         linux-firmware-rpidistro-bcm43455 \
                         bluez-firmware-rpidistro-bcm43430a1-hcd \
                         bluez-firmware-rpidistro-bcm4345c0-hcd \
"

hd_path_squashfs = "${HDEPLOY_PATH_EXTRAS}/base_image"

do_hilscher_deploy_append() {
        for file in $(find ${IMGDEPLOYDIR} -type l -name "*.squashfs"); do
                cp -a $(readlink -f $file) ${hd_path_squashfs}
        done
}
do_hilscher_deploy[cleandirs] += " ${hd_path_squashfs}/ "

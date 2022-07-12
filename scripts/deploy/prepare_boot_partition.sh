#!/bin/bash

echo "preparing bootpartion for netpi $1"

cp ${DEPLOY_DIR_IMAGE}/fitImage-core-image-minimal-initramfs*.bin fitImage

echo ${FIRMWARE_VERSION} > VERSION

if [ "${image_type}" == "production_scan" ] ; then
    cp ${DEPLOY_DIR_IMAGE}/boot-script-fit/fitImage-boot-scan.scr boot-fit.scr
    cp ${DEPLOY_DIR_IMAGE}/boot-script-fit/fitImage-boot-scan.scr boot-fit

    # Copy production_scan_image squash fs
    production_image="$(dirname ${ROOTFS})/production-scan-image.rootfs.squashfs"
    cp ${production_image} rootfs.img
    openssl dgst ${engine_params} -sha512 -sign ${signing_key} -out rootfs.img.sig rootfs.img
elif [ "${image_type}" == "update" ] ; then
    cp ${DEPLOY_DIR_IMAGE}/boot-script-fit/fitImage-boot-update.scr boot-fit.scr
    cp ${DEPLOY_DIR_IMAGE}/boot-script-fit/fitImage-boot-update.scr boot-fit
else
    cp ${DEPLOY_DIR_IMAGE}/boot-script-fit/fitImage-boot-recovery.scr boot-fit.scr
    cp ${DEPLOY_DIR_IMAGE}/boot-script-fit/fitImage-boot-recovery.scr boot-fit
fi

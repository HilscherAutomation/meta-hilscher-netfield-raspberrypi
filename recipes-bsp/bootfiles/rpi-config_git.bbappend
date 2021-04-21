do_deploy_append() {
    echo "dtoverlay=led-gpio" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    echo "dtoverlay=spi1-1cs" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    echo "dtparam=audio=on" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
    echo "force_turbo=1" >> ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
}

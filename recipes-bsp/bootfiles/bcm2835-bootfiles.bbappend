# Increment PR to make sure this package is rebuilt, as we moved to meta-raspberrybase which is just different
# in inherits and somehow used from sstate-cache, even if different files are deployed
PR="r4"

do_install:append() {
    install -d ${D}/boot

    for i in ${S}/*.elf; do
        cp $i ${D}/boot
    done
    for i in ${S}/*.dat ; do
        cp $i ${D}/boot
    done
    for i in ${S}/*.bin ; do
        cp $i ${D}/boot
    done

    # Delete RPI4 stuff
    rm ${D}/boot/start4*.elf ${D}/boot/fixup4*.dat

    # Add stamp in deploy directory
    touch ${D}/boot/${PN}-${PV}.stamp
}

do_deploy:append() {
    # Delete RPI4 stuff
    rm ${DEPLOYDIR}/${PN}/start4*.elf ${DEPLOYDIR}/${PN}/fixup4*.dat
}

INSANE_SKIP = "arch"
FILES:${PN} = "/boot"

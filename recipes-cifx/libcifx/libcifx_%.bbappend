PACKAGECONFIG = "tun spm"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://R160D000.nxf"

do_install:append() {
    install -d ${D}/opt/cifx/FW
    install ${WORKDIR}/R160D000.nxf ${D}/opt/cifx/FW

    install -d ${D}/opt/cifx/deviceconfig/FW/channel0
    ln -s /opt/cifx/FW/R160D000.nxf ${D}/opt/cifx/deviceconfig/FW/channel0/default.nxf

    sed -i "s/irq=.*/irq=yes/g" "${D}/opt/cifx/deviceconfig/FW/device.conf"
    if [ -n "$(grep "Irq" ${D}/opt/cifx/plugins/netx-spm/config0)" ];then
      sed -i "s/Irq=.*/Irq=\/sys\/class\/gpio\/gpio24\/value/g" "${D}/opt/cifx/plugins/netx-spm/config0"
    else
      echo "Irq=/sys/class/gpio/gpio24/value" >> ${D}/opt/cifx/plugins/netx-spm/config0
    fi
}

FILES:${PN}:append = " /opt/cifx/deviceconfig/FW/channel0 /opt/cifx/FW"


do_install:append () {
    # remove rpi rules as they will not apply as the "device" groups (spi,gpio,...) do not exist under netFIELD-OS
    rm ${D}${sysconfdir}/udev/rules.d/99-com.rules
}

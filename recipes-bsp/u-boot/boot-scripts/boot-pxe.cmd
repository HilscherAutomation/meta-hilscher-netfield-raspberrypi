# Create a bootmenu based on boot.cfg files

fdt addr $fdt_addr && fdt get value bootargs /chosen bootargs

fdt get value testval soc/serial@7e215040 autoload
if test $? = 0 ; then
        fdt set soc/serial@7e215040 status okay
        setenv bootargs "$bootargs 8250.nr_uarts=1 "
fi

testaddr=0x20000000

# menu index count
setexpr mi 0
for conf in boot.cfg aboot.cfg rboot.cfg; do
        for part in 3 2; do
                test "${part}" = "3" && partname="system"
                test "${part}" = "2" && partname="rescue"
                if load mmc ${mmcdev}:${part} ${testaddr} ${conf}; then
                        env import ${testaddr} 0x100
                        test -z "${description}" && description="unknown"
                        test "${conf}" = "boot.cfg" && type=" "
                        test "${conf}" = "aboot.cfg" && type="(ALTERNATIVE)"
                        test "${conf}" = "rboot.cfg" && type="(RESCUE)"
                        bootcfg=""
                        setenv bootmenu_${mi} ${description} ${type} = "
                                setenv bootargs $bootargs bootCfg=LABEL=${partname}/${conf} rootfstype=squashfs @OVERLAYS@ rootflags=noatime,discard overlayflags=noatime,discard ro rootwait logo.nologo cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 loglevel=4;
                                fdt addr $fdtcontroladdr;
                                load mmc ${mmcdev}:${part} ${testaddr} ${kernel};
                                bootm ${testaddr} ${testaddr} ${fdt_addr};
                        "
                        setexpr mi ${mi} + 1
                fi
        done
done
# NOTE: Currently we reset the boot entry counter to make
#       sure to start pxe boot every time. For future use
#       case just remove line "mi=0" and pxe boot will
#       start only when boot config is not found.
setexpr mi 0
if test $mi = 0; then
        fdt addr $fdtcontroladdr
        setenv kernel_addr_r 0x20000000
        setenv ramdisk_addr_r 0x20000000
        setenv fdt_addr_r $fdt_addr
        setenv loadaddr 0x20000000
        dhcp

        #pxe
        #setenv pxeuuid 550e8400-e29b-41d4-a716-446655440000
        setenv pxefile_addr_r 0x20000000
        pxe boot
else
    bootmenu 3
fi

exit $?


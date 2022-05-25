# Create a bootmenu based on boot.cfg files

fdt addr $fdt_addr && fdt get value bootargs /chosen bootargs

fdt get value testval soc/serial@7e215040 autoload
if test $? = 0 ; then
        fdt set soc/serial@7e215040 status okay
        setenv bootargs "$bootargs 8250.nr_uarts=1 "
fi

setenv bootargs "$bootargs firmware_class.path=/usr/local/lib/firmware "

# menu index count
setexpr mi 0

for conf in boot.cfg aboot.cfg rboot.cfg; do
        for part in 3 2; do
                test "${part}" = "3" && partname="system"
                test "${part}" = "2" && partname="rescue"
                if load mmc ${mmcdev}:${part} ${loadaddr} ${conf}; then
                        env import ${loadaddr} 0x100
                        test -z "${description}" && description="unknown"
                        test "${conf}" = "boot.cfg" && type=""
                        test "${conf}" = "aboot.cfg" && type="(ALTERNATIVE)"
                        test "${conf}" = "rboot.cfg" && type="(RESCUE)"
                        bootcfg=""
                        setenv bootmenu_${mi} ${description} ${type} = "
                                setenv bootargs $bootargs bootCfg=LABEL=${partname}/${conf} rootfstype=squashfs rootflags=noatime overlayflags=noatime ro rootwait logo.nologo cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 loglevel=4;
                                fdt addr $fdtcontroladdr;
                                load mmc ${mmcdev}:${part} ${loadaddr} ${kernel};
                                bootm ${loadaddr} ${loadaddr} ${fdt_addr};
                        "
                        setexpr mi ${mi} + 1
                fi
        done
done

setenv bootmenu_${mi} FastBoot = "run fastboot"

bootmenu 3

exit $?

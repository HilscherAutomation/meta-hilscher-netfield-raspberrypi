echo "booting recovery-image from usb"

fdt addr $fdt_addr && fdt get value bootargs /chosen bootargs
setenv bootargs "$bootargs bootCfg='' root=LABEL=RECOVERY rootwait logo.nologo dwc_otg.fiq_enable=0 dwc_otg.fiq_fsm_enable=0 loglevel=4"
usb dev 0

fdt addr $fdtcontroladdr
fatload usb 0:1 0x20000000 Image
bootm 0x20000000 0x20000000 ${fdt_addr}

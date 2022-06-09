echo "booting recovery-image from usb"

fdt addr $fdt_addr && fdt get value bootargs /chosen bootargs
setenv bootargs "$bootargs root=LABEL=RECOVERY loglevel=4"
usb dev 0

fdt addr $fdtcontroladdr
fatload usb 0:1 0x20000000 Image
bootm 0x20000000 0x20000000 ${fdt_addr}

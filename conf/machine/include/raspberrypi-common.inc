require conf/machine/raspberrypi3.conf

MACHINE_FEATURES_append += "3g"

ENABLE_SPI_BUS="1"
ENABLE_I2C="1"
HDMI_FORCE_HOTPLUG="1"
HDMI_DRIVE="2"
CORE_FREQ="400"
SERIAL_CONSOLES = ""

#BSP_DEPLOYSCRIPT_DIR?="${DYNAMIC_LAYER_DIR_BASE}/meta-raspberrypi/scripts/deploy"
BSP_DEPLOYSCRIPT_DIR ??= "${TOPDIR}/../meta-hilscher-netfield-intel/scripts/deploy"

#############################################################################
IMAGE_CLASSES_append += "hilscher_image_types"
IMAGE_FSTYPES += "squashfs wic.bz2 swu licenses.tar.bz2"

#############################################################################
# Kernel
#############################################################################
KERNEL_CLASSES_append += "kernel-fitimage"
KERNEL_IMAGETYPES_append += "fitImage"

#############################################################################
# Preferred components/settings
#############################################################################
KERNEL_DEVICETREE = "bcm2710-rpi-3-b.dtb"
RPI_KERNEL_DEVICETREE_OVERLAYS = " \
	overlays/spi1-1cs.dtbo \
	overlays/led-gpio.dtbo \
"
PREFERRED_PROVIDER_virtual/kernel = "linux-raspberrypi"
PREFERRED_VERSION_linux-raspberrypi = "5.4.%"

INITRAMFS_IMAGE ?= "core-image-minimal-initramfs"
HILSCHER_RESCUE_IMAGE ??= "hilscher-rescue-image"

#############################################################################
# Keys
#############################################################################
PLATFORM_SIGN ??= "1"
PLATFORM_KEYDIR ??= "${KEYS_DIR}/boot"
PLATFORM_KEYNAME ??= "db"

#KEYS_DIR ??= "${DYNAMIC_LAYER_DIR_BASE}/meta-raspberrypi/keys/${MACHINE}"
KEYS_DIR .= "/${MACHINE}"
KEYS_IMAGE_SIGN_PRIV ??= "${KEYS_DIR}/boot/db.key"
KEYS_IMAGE_SIGN_CERT ??= "${KEYS_DIR}/boot/db.crt"
KEYS_IMAGE_SIGN_CERT_DER ??= "${KEYS_DIR}/boot/db.crt.der"

FIT_HASH_ALG = "sha256"
FIT_SIGN_ALG = "rsa4096"

#############################################################################
# Bootloader
#############################################################################
RPI_USE_U_BOOT = "1"
UBOOT_DTB_BINARY = ""
UBOOT_SIGN_ENABLE = "1"
UBOOT_SIGN_KEYDIR = "${KEYS_DIR}/boot/"
UBOOT_SIGN_KEYNAME = "db"
UBOOT_MKIMAGE_DTCOPTS = "-I dts -O dtb -p 2000"

#############################################################################
# Contents of boot partition (excluding rootfs)
#############################################################################
IMAGE_BOOT_FILES = " \
	${BOOTFILES_DIR_NAME}/* \
	u-boot.bin;${SDIMG_KERNELIMAGE} \
	bcm2710-rpi-3-b.dtb;bcm2710-rpi-3-b.dtb \
"
# depending on the image settings choose the correct boot script
SCRIPT_SUFFIX = "${@bb.utils.contains('IMAGE_FEATURES', 'debug-tweaks', '-debug.scr', "-fastboot.scr" ,d)}"
IMAGE_BOOT_FILES += "boot-script-fit/fitImage-boot-menu${SCRIPT_SUFFIX};boot-fit.scr"

#############################################################################
# WIC images
#############################################################################
WIC_IMAGE_DEPENDENCIES_append += "bootfiles boot-script-fit"
WKS_FILE = "hilscher-msdos-boot-rescue-system-lvm.wks.in"

WIC_BOOT_PART_CONTENT ??= "${IMAGE_BOOT_FILES}"
WIC_RESCUE_PART_CONTENT ??= ""
WIC_SYSTEM_PART_CONTENT ??= "${IMAGE_LINK_NAME}.squashfs boot.cfg fitImage initrd-api-part-cfg"

#############################################################################
# SWU images
#############################################################################
SWU_SCRIPTS += "swupdate/helper.lua;helper.lua"

SWU_RSYNC_PART_UPDATE ??= "boot system"
SWU_BOOT_PART_CONTENT ??= "${IMAGE_BOOT_FILES}"
SWU_SYSTEM_PART_CONTENT ??= "${IMAGE_LINK_NAME}.squashfs nboot.cfg fitImage"

#############################################################################
# System Partitioning
#############################################################################
# Physical device of system partitions
PHYSICAL_SYSTEM_DEVICE ??= "/dev/mmcblk0 /dev/mmcblk1"
# Size of boot partition
IMAGE_PART_BOOT_SIZE ??= "64M"
# Size of rescue partition
IMAGE_PART_RESCUE_SIZE ??= "128M"
# Size of system partition
IMAGE_PART_SYSTEM_SIZE ??= "1G"
# Size of data partition
IMAGE_PART_DATA_SIZE ??= "max"
# Size of logical volume "data" in userdata partition
PART_DATA_LV_DATA_SIZE ??= "60%VG"
# Size of logical volume "backup" in userdata partition
PART_DATA_LV_BACKUP_SIZE ??= "35%VG"
# Size of logical volume "snapshot" in userdata partition
PART_DATA_LV_SNAPSHOT_SIZE ??= "5%VG"

#############################################################################
# rootfs overlay
#############################################################################
HILSCHER_OVERLAY ??= "/dev/mapper/data-data"
HILSCHER_OVERLAYTARGETS ??= "${NETIOT_OVERLAY_DIRS}"

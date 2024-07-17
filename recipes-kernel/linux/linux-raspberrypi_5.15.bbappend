FILESEXTRAPATHS:prepend := "${THISDIR}/linux-raspberrypi_5.15:"

DEPENDS:append = " virtual/bootloader"

SRCREV_meta="3dd458be964635c8e682a1fb6f9a3368a747f92b"
SRCREV_machine="14b35093ca68bf2c81bbc90aace5007142b40b40"

# Update kernel via patch, as it is not yet available mainline
LINUX_VERSION="5.15.162"
SRC_URI:append = " file://linux-5.15.92-to-162.patch.gz"
addtask do_kernel_version_sanity_check after do_patch

require cve-exclusions.inc

SRC_URI:append = " file://0001-Revert-cgroup-Disable-cgroup-memory-by-default.patch \
                   file://enable_debugfs.cfg \
                   file://enable_tcm.cfg \
                   file://enable_obsolete_sysfs_gpio.cfg"



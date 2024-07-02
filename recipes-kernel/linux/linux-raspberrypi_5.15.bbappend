FILESEXTRAPATHS:prepend := "${THISDIR}/linux-raspberrypi_5.15:"

DEPENDS:append = " virtual/bootloader"

SRCREV_meta="3dd458be964635c8e682a1fb6f9a3368a747f92b"
SRCREV_machine="14b35093ca68bf2c81bbc90aace5007142b40b40"

LINUX_VERSION="5.15.92"
# SRC_URI:remove = "git://github.com/raspberrypi/linux.git;name=machine;branch=${LINUX_RPI_BRANCH}"
# SRC_URI:append = " git://bitbucket.hilscher.com/scm/netfieldos/linux-rasperrypi.git;branch=rpi-5.15.y-update;protocol=https;name=machine"

SRC_URI:append = " file://0001-Revert-cgroup-Disable-cgroup-memory-by-default.patch \
                   file://enable_debugfs.cfg \
                   file://enable_tcm.cfg \
                   file://enable_obsolete_sysfs_gpio.cfg"

# Backport new regulatory database keys to allow loading new wireless-regdb
SRC_URI:append = " file://0001-wifi-cfg80211-Add-my-certificate.patch \
                   file://0002-wifi-cfg80211-fix-certs-build-to-not-depend-on-file-.patch"

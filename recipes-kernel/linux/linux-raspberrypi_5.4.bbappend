FILESEXTRAPATHS_prepend := "${THISDIR}/linux-raspberrypi_5.4:"

SRCREV_meta="ee9020d3cb8056f5142b3ddcc209005fc108a79e"
SRCREV_machine="bcda2d15934d479c9ceca57b732e7143230a10a7"

LINUX_VERSION="5.4.280"
SRC_URI_remove += "git://github.com/raspberrypi/linux.git;name=machine;branch=${LINUX_RPI_BRANCH}"
SRC_URI_append += "git://bitbucket.hilscher.com/scm/netfieldos/linux-rasperrypi.git;branch=rpi-5.4.y-update;protocol=https;name=machine \
    file://0001-Revert-cgroup-Disable-cgroup-memory-by-default.patch \
"

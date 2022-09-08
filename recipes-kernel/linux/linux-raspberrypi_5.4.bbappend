FILESEXTRAPATHS_prepend := "${THISDIR}/linux-raspberrypi_5.4:"

SRCREV_meta="028688aaad2b64e353d771ba5505a8666cd01696"
SRCREV_machine="e0230fe35e639745545f8611b5acf91a0ad7a30a"

LINUX_VERSION="5.4.209"
SRC_URI_remove += "git://github.com/raspberrypi/linux.git;name=machine;branch=${LINUX_RPI_BRANCH}"
SRC_URI_append += "git://bitbucket.hilscher.com/scm/netfieldos/linux-rasperrypi.git;branch=rpi-5.4.y-update;protocol=https;name=machine"

SUMMARY = "ADD-ON BOARDS AND HATs module specification and tools"
HOMEPAGE = "https://github.com/raspberrypi/hats"

SECTION = "devel"

LICENSE = "CLOSED"

SRC_URI = "git://github.com/raspberrypi/hats.git;branch=master;protocol=https"
SRCREV = "55b1b6dec119dabf026b77587da7c2e5cf3f6024"
S="${WORKDIR}/git/eepromutils"
PV="git${SRCPV}"

do_configure() {
}

do_compile() {
  oe_runmake all
}

do_install() {
  install -d ${D}/opt/rpi-hats-eepromutils
  install ${S}/eepmake ${D}/opt/rpi-hats-eepromutils
  install ${S}/eepdump ${D}/opt/rpi-hats-eepromutils
  install ${S}/eepflash.sh ${D}/opt/rpi-hats-eepromutils
}

FILES:${PN} = "/opt/rpi-hats-eepromutils/"

INHIBIT_PACKAGE_DEBUG_SPLIT="1"
# no GNU_HASH in binary
INSANE_SKIP:${PN} = "ldflags"

SECURITY_STRINGFORMAT=""

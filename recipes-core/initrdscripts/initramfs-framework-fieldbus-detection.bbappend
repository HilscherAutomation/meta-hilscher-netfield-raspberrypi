FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

RDEPENDS_${PN}_append += "kernel-module-spi-bcm2835 kernel-module-spi-bcm2835aux"

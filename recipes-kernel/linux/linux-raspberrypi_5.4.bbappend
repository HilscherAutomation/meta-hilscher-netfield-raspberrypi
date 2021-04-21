FILESEXTRAPATHS_prepend := "${THISDIR}/linux-raspberrypi_5.4:"

SRCREV_meta="e872ef155c596e4cc2f68405d85ab6f2b0303c28"

# RPI4: CM4 is not supported until kernel 5.4.79 and dunfell is at 5.4.72
#       Using default rpi4 dts makes the kernel panic with pcie card attached
# RPI3: Kernel contains a link detection fix for USB ethernet adapter
LINUX_VERSION="5.4.83"
SRCREV_machine="cf14b2710bf63ea250e46a5e5fa54144ef51af76"

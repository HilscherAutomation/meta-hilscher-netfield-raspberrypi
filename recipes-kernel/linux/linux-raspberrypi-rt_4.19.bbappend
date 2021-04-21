FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-4.19:"

# BCM2708_FB driver seems to produce bad screens on our HW (yellow lines)
SRC_URI_append += "file://disable_bcm2708_fb.cfg"
SRC_URI_append += "file://rpi3b_4.9_compatibility.patch \
                   file://irqchip_bcm2835_qiesce_irqs_left_by_bootloader.patch \
                   file://fix_dma_mmc_hang.patch"

LINUX_VERSION = "4.19.71"
SRCREV = "e2e9cec6fb061ba58304fd391ef76747f2963557"
SRCREV_meta="20a6158aa35dbf11819382ef1eeb28915afea765"

# ATTENTION: When updating recipe, make sure to recheck if whitelisted CVEs still apply
# Following are already patched upstream
CVE_CHECK_WHITELIST_append += "CVE-2019-18805 CVE-2019-15926 CVE-2019-15292 CVE-2019-10126 \
                               CVE-2018-20784"

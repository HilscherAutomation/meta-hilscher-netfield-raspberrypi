SUMMARY = "system init service"
DESCRIPTION = ""
LICENSE = "CLOSED"

SRC_URI = "file://system-init.service"

do_install() {
  install -d ${D}/${systemd_unitdir}/system/
  install -m 0644 ${WORKDIR}/system-init.service ${D}/${systemd_unitdir}/system/

  install -d ${D}/etc/systemd/system/multi-user.target.wants/
  ln -s ${systemd_unitdir}/system/system-init.service ${D}/etc/systemd/system/multi-user.target.wants/system-init.service
}

FILES:${PN} += "/lib/systemd/system/system-init.service"
FILES:${PN} += " /etc/systemd/system/multi-user.target.wants/system-init.service"
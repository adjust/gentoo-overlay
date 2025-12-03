# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

# Upstream version format: 008.0015.0000.0010
MY_PV="008.0015.0000.0010"
MY_P="storcli2-${MY_PV}"
MY_PN="StorCLI_Avenger_8.15-008"
DESCRIPTION="MegaRAID StorCLI (successor of the MegaCLI)"
HOMEPAGE="https://www.broadcom.com/support/download-search?dk=storcli"
SRC_URI="
  https://files.adjust.com/StorCLI_Avenger_8.15-008.0015.0000.0010.tar.gz -> ${P}.tar.gz
"

LICENSE="Avago LSI BSD"
SLOT="0"
KEYWORDS="-* ~amd64"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/StorCLI_Avenger_8.15-008.0015.0000.0010"

QA_PREBUILT="/opt/MegaRAID/storcli/storcli64"

src_unpack() {
	default
	rpm_unpack "${S}/Avenger_StorCLI/Linux/${MY_P}-1.x86_64.rpm"
}

src_install() {
	exeinto /opt/MegaRAID/storcli
	doexe "${WORKDIR}/opt/MegaRAID/storcli2/storcli2"

	dosym /opt/MegaRAID/storcli/storcli2 /usr/sbin/storcli
}

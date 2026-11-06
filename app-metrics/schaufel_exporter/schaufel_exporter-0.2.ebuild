# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="VictoriaMetrics exporter for schaufels stats"
HOMEPAGE="https://github.com/adjust/schaufel"

SLOT="0"
IUSE=""

KEYWORDS="~amd64"
LICENSE="Apache-2.0"

RDEPEND="
	app-admin/schaufel
	dev-perl/libwww-perl
	dev-perl/HTTP-Message
	dev-perl/Try-Tiny
	dev-perl/JSON
  dev-perl/YAML-LibYAML
"
S=${FILESDIR}
src_install() {
	newinitd "${FILESDIR}"/"${PN}".initd "${PN}"
	newconfd "${FILESDIR}"/"${PN}".confd "${PN}"
	insinto /usr/local/sbin
	newins "${FILESDIR}"/"${PN}".pl "${PN}.pl" 
	fowners schaufel:schaufel /usr/local/sbin/"${PN}".pl
	fperms 0550 /usr/local/sbin/"${PN}".pl
  keepdir /etc/"${PN}"
  fowners schaufel:schaufel /etc/${PN}
  insinto /etc/"${PN}"
  newins "${FILESDIR}"/config.yaml config.yaml
  fowners schaufel:schaufel /etc/"${PN}"/config.yaml
}

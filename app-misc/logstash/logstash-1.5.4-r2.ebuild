# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool for managing events and logs"
HOMEPAGE="https://www.elastic.co/products/logstash"
SRC_URI="https://download.elastic.co/${PN}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=virtual/jre-1.8
"

DEPEND="
	>=virtual/jdk-1.8
	acct-group/logstash
	acct-user/logstash
"

src_install() {
	dodir "/etc/logstash/conf.d"

	dodir "/opt"
	cp -R "${S}/" "${D}/opt/${PN}" || die "Failed to install to /opt"

	dobin "${FILESDIR}/logstash"

	insinto "/etc/logrotate.d"
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	keepdir "/var/log/${PN}"
}

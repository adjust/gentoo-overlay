# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Distributed tracing backend - binary package"
HOMEPAGE="https://github.com/grafana/tempo"
SRC_URI="
	https://github.com/grafana/tempo/releases/download/v${PV}/tempo_${PV}_linux_amd64.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="
	/opt/bin/tempo
	/opt/bin/tempo-cli
	/opt/bin/tempo-query
"

QA_PRESTRIPPED="
	/opt/bin/tempo
	/opt/bin/tempo-cli
	/opt/bin/tempo-query
"

RESTRICT="mirror strip"

src_install() {
	newinitd "${FILESDIR}/tempo.initd" "grafana-tempo"
	dodoc *.md
	into /opt
	dobin tempo*
	insinto /etc
	doins "${FILESDIR}/tempo.yml"
}

pkg_postinst() {
	einfo
	einfo "Please make sure to modify /etc/tempo.yml before starting Grafana Tempo!"
	einfo
}

# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Promtail is an agent which ships the contents of local logs to a Loki instance."
HOMEPAGE="https://grafana.com/loki"
SRC_URI="https://github.com/grafana/loki/releases/download/v${PV}/promtail-linux-amd64.zip -> ${P}.zip"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
    app-arch/zip
    >=dev-lang/go-1.13:*
"

QA_PREBUILT="/opt/bin/promtail"
QA_PRESTRIPPED="/opt/bin/promtail"

RESTRICT="mirror strip"

src_install() {
    newinitd "${FILESDIR}/promtail.initd" "promtail"
	dodoc *.md
	into /opt
	newbin promtail-linux-amd64 promtail
    insinto /etc
	doins "${FILESDIR}/promtail.yml"
}

pkg_postinst() {
	einfo
	einfo "Please make sure to modify /etc/promtail.yml before starting Promtail!"
	einfo
}

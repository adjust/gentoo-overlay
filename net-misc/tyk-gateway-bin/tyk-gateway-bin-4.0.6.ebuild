# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="API access control"
HOMEPAGE="https://github.com/TykTechnologies/tyk"
SRC_URI="
	https://files.adjust.com/${P}.tar.gz
"

S="${WORKDIR}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="
	/opt/bin/tyk
"

QA_PRESTRIPPED="
	/opt/bin/tyk
"

RESTRICT="mirror strip"

src_prepare() {
	default
	rm -r lib etc opt/share opt/tyk-gateway/install opt/tyk || die
}

src_install() {
	newinitd "${FILESDIR}/tyk-gateway.initd" "tyk-gateway"
	insinto /etc
	doins opt/tyk-gateway/tyk.conf
	insinto /opt/tyk-gateway
	doins -r opt/tyk-gateway/{apps,event_handlers,middleware,policies,templates,coprocess}
	into /opt
	dobin opt/tyk-gateway/tyk
}

pkg_postinst() {
	einfo
	einfo "Please make sure to modify /etc/tyk.yml before starting tyk!"
	einfo
}

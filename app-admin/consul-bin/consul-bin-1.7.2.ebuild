# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

MY_PN="${PN/-bin/}"

DESCRIPTION="Cluster manager from Hashicorp"
HOMEPAGE="https://www.consul.io"
SRC_URI="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_linux_amd64.zip -> ${P}.zip"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	!app-admin/consul
	acct-group/consul
	acct-user/consul
"

DEPEND="
	${RDEPEND}
"

S="${WORKDIR}"

src_install() {
	local x

	dobin "${S}/consul" || die

	for x in /var/{lib,log}/${MY_PN}; do
		keepdir "${x}"
		fowners ${MY_PN}:${MY_PN} "${x}"
	done

	newinitd "${FILESDIR}/${MY_PN}.initd" "${MY_PN}"
	newconfd "${FILESDIR}/${MY_PN}.confd" "${MY_PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate" "${MY_PN}"
}

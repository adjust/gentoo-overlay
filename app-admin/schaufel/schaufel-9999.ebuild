# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="shovel data around"
HOMEPAGE="https://github.com/adjust/schaufel"
SRC_URI="https://github.com/adjust/${PN}/archive/master.tar.gz -> ${PN}-master.tar.gz"

RESTRICT="fetch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
>=dev-libs/librdkafka-0.9.4[lz4]
dev-libs/hiredis
"

S="${WORKDIR}/${PN}-master"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_install() {
	emake PREFIX="${D}" install
	insinto /usr/bin
	doins "${D}/${PN}"
	fperms +x /usr/bin/${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	diropts -m 0755 -o ${PN} -g ${PN}
	keepdir /var/{log,lib}/${PN}
}

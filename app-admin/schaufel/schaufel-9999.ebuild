# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="shovel data around"
HOMEPAGE="https://github.com/adjust/schaufel"
SRC_URI="https://github.com/adjust/schaufel/archive/${PN}-9999.tar.gz"

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

S="${WORKDIR}/${PN}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_install() {
	emake PREFIX="${D}" install
	insinto /usr/bin
	doins "${D}/${PN}"
}

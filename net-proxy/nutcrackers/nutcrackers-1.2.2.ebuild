# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Multithreaded Nutcracker (Twemproxy)"
HOMEPAGE="https://github.com/vipshop/twemproxies"
SRC_URI="https://files.adjust.com/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

DEPEND=">=dev-libs/libyaml-0.1.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/nutcrackers"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.1-use-system-libyaml.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use debug) || die "Econf failed"
}

src_install() {
	default_src_install

	insinto /etc/nutcracker
	newins conf/nutcracker.yml nutcracker.yml.example

	newconfd "${FILESDIR}/nutcracker.confd.2" nutcracker
	newinitd "${FILESDIR}/nutcracker.initd.2" nutcracker

	if use doc; then
		dodoc -r notes
	fi
}

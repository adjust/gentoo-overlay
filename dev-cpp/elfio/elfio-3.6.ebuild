# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ELFIO"
DESCRIPTION="ELF reader/producer header-only C++ library"
HOMEPAGE="https://github.com/serge1/ELFIO"
SRC_URI="https://github.com/serge1/${PN}/archive/Release_${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/boost )"

S=${WORKDIR}/${MY_PN}-Release_${PV}

src_configure() {
	default

	if use test ; then
		cd "${S}/ELFIOTest" || die
		econf
	fi
}

src_test() {
	cd "${S}/ELFIOTest" || die
	emake
	./runELFtests || die
}

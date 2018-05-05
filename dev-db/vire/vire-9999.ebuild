# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

WANT_AUTOMAKE="1.15"
inherit git-r3 autotools

DESCRIPTION="Multithreaded in-memory database that talks redis protocol"
HOMEPAGE="https://github.com/vipshop/vire"
LICENSE="Apache-2.0"

EGIT_REPO_URI="https://github.com/vipshop/vire.git"

SLOT=0
IUSE=""
KEYWORDS="~amd64"

DEPEND=""
#	dev-libs/jemalloc
#	dev-libs/hiredis
#	"

src_prepare() {
	#rm -rf dep/hiredis* dep/jemalloc*
	#eautoreconf # this fails
	autoreconf -vfi # this fails less
	eapply_user
}

src_compile() {
	unset ARCH
	emake
}

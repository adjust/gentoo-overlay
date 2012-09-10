# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2 eutils

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE="BeerBSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-libs/gloox
		>=dev-lang/lua-5.1.0
		dev-libs/openssl
		>=sys-devel/gcc-4.6.3"

RDEPEND="${DEPEND}"

EGIT_REPO_URI="git://github.com/roa/dramaqueen.git"

pkg_setup() {
	ebegin "Creating dramaqueen group and user"
	enewgroup dramaqueen
	enewuser  dramaqueen -1 -1 -1 "dramaqueen"
	eend $?
}

src_compile() {
	make release || die "Something went terribly wrong..."
}

src_install() {
    dodir "/usr/local/bin/"
	cp "${PORTAGE_BUILDDIR}/work/dramaqueen-0.01/bin/Release/dramaqueen" \
	"${D}/usr/local/bin/" || die
	
	dodir "/etc/dramaqueen"
	cp "${FILESDIR}/init.lua" \
	"${D}/etc/dramaqueen" || die

	dodir	/var/lib/dramaqueen \
			/var/lib/dramaqueen/script \
			/var/lib/dramaqueen/daemon/ \

	keepdir /var/lib/dramaqueen/script/
	keepdir/var/lib/dramaqueen/daemon/

	fowners -R dramaqueen.dramaqueen "/var/lib/dramaqueen"
	fperms -R 0700 "/var/lib/dramaqueen"
	
	dodir /var/log/dramaqueen
	fowners -R dramaqueen:dramaqueen "/var/log/dramaqueen"
	keepdir /var/log/dramaqueen
	fperms -R 0700 "/var/log/dramaqueen"

	doinitd "${FILESDIR}"/init.d/dramaqueen
}

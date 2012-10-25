# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/phantomjs/phantomjs-1.6.0.ebuild,v 1.1 2012/01/17 16:11:50 vapier Exp $

EAPI="2"

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

DESCRIPTION="headless WebKit with JavaScript API"
HOMEPAGE="http://www.phantomjs.org/"

SRC_URI="https://phantomjs.googlecode.com/files/phantomjs-1.7.0-linux-x86_64.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	dodir /usr/bin/ 
	cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.7.0-linux-x86_64/bin/phantomjs" "${D}/usr/bin/" || die
}

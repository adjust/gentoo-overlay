# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/phantomjs/phantomjs-1.6.0.ebuild,v 1.1 2012/01/17 16:11:50 vapier Exp $

EAPI="2"

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

DESCRIPTION="headless WebKit with JavaScript API"
HOMEPAGE="http://www.phantomjs.org/"

SRC_URI="http://phantomjs.googlecode.com/files/phantomjs-1.6.0-linux-x86_64-dynamic.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_install() {
	dodir /usr/bin/ 
	cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/bin/phantomjs" "${D}/usr/bin/" || die
	dodir /usr/lib/ 
	cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/lib/libQtCore.so.4" "${D}/usr/lib/" || die
	cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/lib/libQtGui.so.4" "${D}/usr/lib/" || die
	cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/lib/libQtNetwork.so.4" "${D}/usr/lib/" || die
	cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/lib/libQtWebKit.so.4" "${D}/usr/lib/" || die
	if [ -f /usr/lib/libfontconfig.so.1 ]
	then
		echo "exist"
	else
		cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/lib/libfontconfig.so.1" "${D}/usr/lib/" || die
	fi
	if [ -f /usr/lib/libfreetype.so.6 ]
	then
		echo "exist"
	else
		cp "${PORTAGE_BUILDDIR}/work/phantomjs-1.6.0-linux-x86_64-dynamic/lib/libfreetype.so.6" "${D}/usr/lib/" || die
	fi
}

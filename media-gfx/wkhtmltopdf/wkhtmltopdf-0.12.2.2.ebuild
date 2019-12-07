# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qt4-r2 multilib eutils

DESCRIPTION="Convert html to pdf (and various image formats) using webkit"
HOMEPAGE="http://wkhtmltopdf.org/ https://github.com/wkhtmltopdf/wkhtmltopdf/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="
	=dev-qt/qtchooser-0_p20151008-r100
	~dev-qt/qtgui-4.8.5[wkhtmltopdf]
	~dev-qt/qtwebkit-4.8.5[wkhtmltopdf]
	~dev-qt/qtcore-4.8.5[wkhtmltopdf]
	~dev-qt/qtsvg-4.8.5[wkhtmltopdf]
	~dev-qt/qtxmlpatterns-4.8.5[wkhtmltopdf]"
DEPEND="${RDEPEND}"

src_prepare() {
	# fix install paths and don't precompress man pages
	epatch "${FILESDIR}"/${PN}-0.12.1.2-manpages.patch

	sed -i "s:\(INSTALLBASE/\)lib:\1$(get_libdir):" src/lib/lib.pro || die
}

src_configure() {
	eqmake4 INSTALLBASE=/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc AUTHORS CHANGELOG* README.md
	use examples && dodoc -r examples
}

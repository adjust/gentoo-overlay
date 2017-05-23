# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit qt4-build-multilib

DESCRIPTION="The SVG module for the Qt toolkit"

SRC_URI=${SRC_URI/official_releases/archive}
SRC_URI+=" http://files.adjust.com/qt-${PV}-wkhtmltopdf.patch"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="+accessibility wkhtmltopdf"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,wkhtmltopdf=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[accessibility=,aqua=,debug=,wkhtmltopdf=,${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/svg
	src/plugins/imageformats/svg
	src/plugins/iconengines/svgiconengine"

QCONFIG_ADD="svg"
QCONFIG_DEFINE="QT_SVG"

src_prepare() {
	use wkhtmltopdf && epatch "${DISTDIR}/qt-${PV}-wkhtmltopdf.patch"
	qt4-build-multilib_src_prepare
}

multilib_src_configure() {
	local myconf=(
		-svg
		$(qt_use accessibility)
		-no-xkb  -no-xrender
		-no-xrandr -no-xfixes -no-xcursor -no-xinerama -no-xshape -no-sm
		-no-opengl -no-nas-sound -no-dbus -no-cups -no-nis -no-gif -no-libpng
		-no-libmng -no-libjpeg -no-openssl -system-zlib -no-webkit -no-phonon
		-no-qt3support -no-xmlpatterns -no-freetype -no-libtiff
		-no-fontconfig -no-glib -no-gtkstyle
	)
	qt4_multilib_src_configure
}

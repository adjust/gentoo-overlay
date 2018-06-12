# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qt4-build-multilib
MULTILIB_USEDEP_HACK='abi_x86_64(-)?'

DESCRIPTION="The GUI module for the Qt toolkit"

SRC_URI=${SRC_URI/official_releases/archive}
SRC_URI+=" https://dev.gentoo.org/~pesa/patches/${PN}-systemtrayicon-plugin-system.patch
	https://files.adjust.com/qt-${PV}-wkhtmltopdf.patch
"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="+accessibility cups egl +glib gtkstyle mng nas nis tiff trace xinerama +xv wkhtmltopdf"

REQUIRED_USE="
	gtkstyle? ( glib )
"

# cairo[-qt4] is needed because of bug 454066
RDEPEND="
	app-eselect/eselect-qtgraphicssystem
	~dev-qt/qtcore-${PV}[debug=,glib=,wkhtmltopdf=,${MULTILIB_USEDEP_HACK}]
	~dev-qt/qtscript-${PV}[debug=,${MULTILIB_USEDEP_HACK}]
	>=media-libs/fontconfig-2.10.2-r1[${MULTILIB_USEDEP_HACK}]
	>=media-libs/freetype-2.4.11-r1:2[${MULTILIB_USEDEP_HACK}]
	media-libs/libpng:0=[${MULTILIB_USEDEP_HACK}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP_HACK}]
	virtual/jpeg:0[${MULTILIB_USEDEP_HACK}]
	!aqua? (
		>=x11-libs/libICE-1.0.8-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libSM-1.2.1-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libX11-1.5.0-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libXcursor-1.1.13-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libXext-1.3.1-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libXfixes-5.0-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libXi-1.6.2-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libXrandr-1.4.0-r1[${MULTILIB_USEDEP_HACK}]
		>=x11-libs/libXrender-0.9.7-r1[${MULTILIB_USEDEP_HACK}]
		xinerama? ( >=x11-libs/libXinerama-1.1.2-r1[${MULTILIB_USEDEP_HACK}] )
		xv? ( >=x11-libs/libXv-1.0.7-r1[${MULTILIB_USEDEP_HACK}] )
	)
	cups? ( net-print/cups[${MULTILIB_USEDEP_HACK}] )
	egl? ( media-libs/mesa[egl,${MULTILIB_USEDEP_HACK}] )
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP_HACK}] )
	gtkstyle? (
		>=x11-libs/cairo-1.12[-qt4(-),${MULTILIB_USEDEP_HACK}]
		>=x11-libs/gtk+-2.24.23-r1:2[aqua=,${MULTILIB_USEDEP_HACK}]
	)
	mng? ( >=media-libs/libmng-1.0.10-r2:=[${MULTILIB_USEDEP_HACK}] )
	nas? ( >=media-libs/nas-1.9.3-r1[${MULTILIB_USEDEP_HACK}] )
	tiff? ( >=media-libs/tiff-4.0.3-r2:0[${MULTILIB_USEDEP_HACK}] )
	!<dev-qt/qthelp-4.8.5:4
"
DEPEND="${RDEPEND}
	!aqua? (
		x11-base/xorg-proto
	)
"

PATCHES=(
	"${DISTDIR}/${PN}-systemtrayicon-plugin-system.patch" # bug 503880
	"${FILESDIR}/${PN}-4.7.3-cups.patch" # bug 323257
	"${FILESDIR}/${PN}-4.8.5-disable-gtk-theme-check.patch" # bug 491226
	"${FILESDIR}/${PN}-4.8.5-qclipboard-delay.patch" # bug 514968
)

QT4_TARGET_DIRECTORIES="
	src/gui
	src/scripttools
	src/plugins/imageformats/gif
	src/plugins/imageformats/ico
	src/plugins/imageformats/jpeg
	src/plugins/imageformats/tga
	src/plugins/inputmethods"

pkg_setup() {
	use accessibility && QT4_TARGET_DIRECTORIES+=" src/plugins/accessible/widgets"
	use mng && QT4_TARGET_DIRECTORIES+=" src/plugins/imageformats/mng"
	use tiff && QT4_TARGET_DIRECTORIES+=" src/plugins/imageformats/tiff"
	use trace && QT4_TARGET_DIRECTORIES+=" src/plugins/graphicssystems/trace tools/qttracereplay"

	[[ ${CHOST} != *-darwin* ]] && QT4_TARGET_DIRECTORIES+=" tools/qtconfig"

	QCONFIG_ADD="
		mitshm tablet x11sm xcursor xfixes xinput xkb xrandr xrender xshape xsync
		fontconfig system-freetype gif png system-png jpeg system-jpeg
		$(usev accessibility)
		$(usev cups)
		$(use mng && echo system-mng)
		$(usev nas)
		$(usev nis)
		$(use tiff && echo system-tiff)
		$(usev xinerama)
		$(use xv && echo xvideo)"
	QCONFIG_REMOVE="no-freetype no-gif no-jpeg no-png no-gui"
	QCONFIG_DEFINE="$(use accessibility && echo QT_ACCESSIBILITY)
			$(use cups && echo QT_CUPS)
			$(use egl && echo QT_EGL)
			QT_FONTCONFIG QT_FREETYPE
			$(use gtkstyle && echo QT_STYLE_GTK)
			QT_IMAGEFORMAT_JPEG QT_IMAGEFORMAT_PNG
			$(use mng && echo QT_IMAGEFORMAT_MNG)
			$(use nas && echo QT_NAS)
			$(use nis && echo QT_NIS)
			$(use tiff && echo QT_IMAGEFORMAT_TIFF)
			QT_SESSIONMANAGER QT_SHAPE QT_TABLET QT_XCURSOR QT_XFIXES
			$(use xinerama && echo QT_XINERAMA)
			QT_XINPUT QT_XKB QT_XRANDR QT_XRENDER QT_XSYNC
			$(use xv && echo QT_XVIDEO)"
}

src_prepare() {
	use wkhtmltopdf && epatch "${DISTDIR}/qt-${PV}-wkhtmltopdf.patch"
	qt4-build-multilib_src_prepare

	# Add -xvideo to the list of accepted configure options
	sed -i -e 's:|-xinerama|:&-xvideo|:' configure || die
}

multilib_src_configure() {
	local myconf=(
		$(qt_use accessibility)
		$(qt_use cups)
		$(qt_use glib)
		$(qt_use mng libmng system)
		$(qt_use nas nas-sound system)
		$(qt_use nis)
		$(qt_use tiff libtiff system)
		$(qt_use egl)
		-no-qt3support
		$(qt_use gtkstyle)
		$(qt_use xinerama)
		$(qt_use xv xvideo)
		-system-libpng -system-libjpeg -system-zlib
		-no-sql-mysql -no-sql-psql -no-sql-ibase -no-sql-sqlite -no-sql-sqlite2 -no-sql-odbc
		-sm -xshape -xsync -xcursor -xfixes -xrandr -xrender -mitshm -xinput -xkb
		-fontconfig -no-svg -no-webkit -no-phonon -no-opengl
	)
	qt4_multilib_src_configure
}

multilib_src_install_all() {
	qt4_multilib_src_install_all

	dodir /usr/share/qt4/graphicssystems
	echo "default" > "${ED}"/usr/share/qt4/graphicssystems/raster || die
	echo "" > "${ED}"/usr/share/qt4/graphicssystems/native || die

	if has tools/qtconfig ${QT4_TARGET_DIRECTORIES}; then
		newicon tools/qtconfig/images/appicon.png qtconfig.png
		make_desktop_entry qtconfig 'Qt Configuration Tool' qtconfig 'Qt;Settings;DesktopSettings'
	fi
}

pkg_postinst() {
	qt4-build-multilib_pkg_postinst

	# raster is the default graphicssystem, set it on first install
	eselect qtgraphicssystem set raster --use-old
}

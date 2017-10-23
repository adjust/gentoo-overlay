# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qt4-build-multilib
MULTILIB_USEDEP_HACK='abi_x86_64(-)?'

DESCRIPTION="The XmlPatterns module for the Qt toolkit"

SRC_URI=${SRC_URI/official_releases/archive}
SRC_URI+=" https://files.adjust.com/qt-${PV}-wkhtmltopdf.patch"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64"
fi

IUSE="wkhtmltopdf"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,wkhtmltopdf=,${MULTILIB_USEDEP_HACK}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/xmlpatterns
	tools/xmlpatterns
	tools/xmlpatternsvalidator"

QCONFIG_ADD="xmlpatterns"
QCONFIG_DEFINE="QT_XMLPATTERNS"

src_prepare() {
	use wkhtmltopdf && epatch "${DISTDIR}/qt-${PV}-wkhtmltopdf.patch"

	qt4-build-multilib_src_prepare
}

multilib_src_configure() {
	local myconf=(
		-xmlpatterns
	)
	qt4_multilib_src_configure
}

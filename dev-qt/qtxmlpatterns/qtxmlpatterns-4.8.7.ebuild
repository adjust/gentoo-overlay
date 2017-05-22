# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils qt4-build-multilib

DESCRIPTION="The XmlPatterns module for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == release ]]; then
	KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
fi

IUSE="wkhtmltopdf"

DEPEND="
	~dev-qt/qtcore-${PV}[aqua=,debug=,wkhtmltopdf=,${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="
	src/xmlpatterns
	tools/xmlpatterns
	tools/xmlpatternsvalidator"

QCONFIG_ADD="xmlpatterns"
QCONFIG_DEFINE="QT_XMLPATTERNS"

src_prepare() {
	use wkhtmltopdf && epatch "${FILESDIR}/qt-${PV}-wkhtmltopdf.patch"

	qt4_multilib_src_prepare
}

multilib_src_configure() {
	local myconf=(
		-xmlpatterns
	)
	qt4_multilib_src_configure
}

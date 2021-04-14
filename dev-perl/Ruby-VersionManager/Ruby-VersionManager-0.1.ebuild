# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Module to manage ruby versions in non-interactive environments"
HOMEPAGE="https://github.com/adjust/p5-Ruby-VersionManager"
SRC_URI="https://github.com/adjust/p5-Ruby-VersionManager/archive/refs/tags/v${PVR}.tar.gz -> ${PN}-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Moo
	dev-perl/YAML
	dev-perl/libwww-perl
"

RDEPEND="
	${DEPEND}
"

src_unpack() {
	default

        mv "${WORKDIR}"/p5-${PN}-${PV} "${WORKDIR}"/${PN}-${PV}
}

src_install() {
	mytargets="install"
	perl-module_src_install
}

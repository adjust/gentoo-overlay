# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="Module to manage ruby versions in non-interactive environments"
HOMEPAGE="https://github.com/adjust/p5-Ruby-VersionManager"

KEYWORDS="~amd64"
LICENSE="MIT"

SLOT="0"

IUSE=""

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/adjust/p5-Ruby-VersionManager.git"
else
	SRC_URI="https://github.com/adjust/p5-Ruby-VersionManager/archive/v${PVR}.tar.gz"
fi

DEPEND="
    dev-perl/Moo
	dev-perl/YAML
	dev-perl/libwww-perl
"

RDEPEND="
	${DEPEND}
"

src_unpack() {
	unpack v${PVR}.tar.gz
	mv p5-Ruby-VersionManager-${PVR} ${PN}-${PV}
}

src_install() {
	mytargets="install"
	perl-module_src_install
}

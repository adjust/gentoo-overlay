# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="Adjust PostgreSQL Tools"
HOMEPAGE="https://github.com/adjust/postgres_tools"

LICENSE="MIT"

SLOT="0"

IUSE=""

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adjust/postgres_tools.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/adjust/postgres_tools/archive/v${PVR}.tar.gz -> ${P}.tar.gz"
fi

BDEPEND="
	dev-perl/Module-Build
"

DEPEND="
	dev-perl/Moo
	dev-perl/DBD-Pg
	virtual/perl-File-Path
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	dev-perl/Module-Build
	dev-perl/Parallel-ForkManager
	dev-perl/Term-ProgressBar
	dev-perl/File-Rsync
"

RDEPEND="
	${DEPEND}
"

src_unpack() {
	unpack ${P}.tar.gz
	mv postgres_tools-${PVR} ${PN}-${PV}
}

src_install() {
	mytargets="install"
	perl-module_src_install
}

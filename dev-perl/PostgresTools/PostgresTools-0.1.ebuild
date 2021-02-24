# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="Adjust PostgreSQL Tools"
HOMEPAGE="https://github.com/adjust/postgres_tools"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

if [[ ${PV} == 9999 ]]
then
    EGIT_REPO_URI="${HOMEPAGE}.git"
else
    SRC_URI="${HOMEPAGE}/archive/v${PVR}.tar.gz"
fi

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

RDEPEND="${DEPEND}"

src_unpack() {
    unpack v${PVR}.tar.gz
    mv postgres_tools-${PVR} ${PN}-${PV}
}

src_install() {
    mytargets="install"
    perl-module_src_install
}

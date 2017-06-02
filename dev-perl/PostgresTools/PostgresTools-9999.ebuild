# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module git-2

DESCRIPTION="adjust postgres tools"
HOMEPAGE="https://github.com/adjust/postgres_tools"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/postgres_tools.git"
SLOT="0"
KEYWORDS=""
IUSE=""

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

mytargets="install"

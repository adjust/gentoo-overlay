# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module git-r3

DESCRIPTION="adjust bagger tools"
HOMEPAGE="https://github.com/adjust/bagger"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/bagger.git"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-perl/Moo
	dev-perl/DBD-Pg
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	dev-perl/Module-Build
	dev-perl/Parallel-ForkManager
	dev-perl/Term-ProgressBar
	dev-perl/Digest-SHA1
"

RDEPEND="${DEPEND}"

mytargets="install"

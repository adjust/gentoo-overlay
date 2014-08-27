# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
inherit git-2

DESCRIPTION="adjust postgres tools"
HOMEPAGE="https://github.com/adjust/postgres_tools"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adeven/postgres_tools.git"
EGIT_BRANCH="dump-excludes"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/Moo dev-perl/DBD-Pg perl-core/File-Path dev-perl/DateTime dev-perl/DateTime-Format-Strptime dev-perl/Parallel-ForkManager dev-perl/Term-ProgressBar"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

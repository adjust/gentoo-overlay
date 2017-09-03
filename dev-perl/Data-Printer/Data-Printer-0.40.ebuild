# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="GARU"
MODULE_VERSION="0.40"

inherit perl-module

DESCRIPTION="colored pretty-print of Perl data structures and objects"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Sort-Naturally
	dev-perl/Clone-PP
	>=dev-perl/Package-Stash-0.370.0
	dev-perl/File-HomeDir
	dev-lang/perl"

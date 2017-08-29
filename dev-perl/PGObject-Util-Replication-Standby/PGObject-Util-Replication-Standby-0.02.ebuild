# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="EINHVERFR"
MODULE_VERSION="0.02"

inherit perl-module

DESCRIPTION="Manage PG replication standbys"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Moo
	dev-perl/PGObject-Util-Replication-SMO
	>=dev-perl/URI-1.710.0
	dev-lang/perl"

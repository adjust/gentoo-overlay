# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="EINHVERFR"
MODULE_VERSION="1.000000"

inherit perl-module

DESCRIPTION="Replication Server Management Objects!"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/PGObject-Util-PGConfig
	>=dev-perl/DBI-1.634.0
	dev-perl/PGObject-Util-Replication-Slot
	dev-perl/Moo
	dev-perl/DBD-Pg
	dev-perl/Test-Exception
	dev-lang/perl"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="EINHVERFR"
MODULE_VERSION="0.01"

inherit perl-module

DESCRIPTION="Manage Database Masters"
SRC_URI="mirror://cpan/authors/id/E/EI/EINHVERFR/${PN}-v${PV}.tar.gz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/DBI
	dev-perl/DBD-Pg
	dev-perl/Test-Exception
	dev-perl/Moo
	>=dev-perl/PGObject-Util-Replication-Slot-0.020000
	>=dev-perl/PGObject-Util-PGConfig-0.02
	dev-lang/perl"

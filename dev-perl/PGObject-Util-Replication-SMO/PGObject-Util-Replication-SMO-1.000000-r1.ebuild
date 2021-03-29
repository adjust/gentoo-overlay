# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="EINHVERFR"
DIST_VERSION="1.000000"

inherit perl-module

DESCRIPTION="Replication Server Management Objects!"
HOMEPAGE="https://metacpan.org/pod/PGObject::Util::Replication::SMO"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/PGObject-Util-PGConfig
	>=dev-perl/DBI-1.634.0
	dev-perl/PGObject-Util-Replication-Slot
	dev-perl/Moo
	dev-perl/DBD-Pg
	dev-perl/Test-Exception
"

RDEPEND="
	${DEPEND}
"

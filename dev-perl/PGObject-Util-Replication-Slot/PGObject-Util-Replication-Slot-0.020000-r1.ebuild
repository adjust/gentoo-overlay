# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="EINHVERFR"
DIST_VERSION="0.020000"

inherit perl-module

DESCRIPTION="Manage and Monitor Replication Slots"
HOMEPAGE="https://metacpan.org/pod/PGObject::Util::Replication::Slot"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Moo
	dev-perl/DBI
	dev-perl/DBD-Pg
"

RDEPEND="
	${DEPEND}
"

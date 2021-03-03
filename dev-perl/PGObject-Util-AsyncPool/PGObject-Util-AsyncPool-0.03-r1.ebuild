# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="EINHVERFR"
DIST_VERSION="0.03"

inherit perl-module

DESCRIPTION="An Async Connection Pooler for PGObject"
HOMEPAGE="https://metacpan.org/pod/PGObject::Util::AsyncPool"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Test-Exception
	dev-perl/DBD-Pg
"

RDEPEND="
	${DEPEND}
"

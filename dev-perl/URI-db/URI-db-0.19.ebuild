# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DWHEELER"
DIST_VERSION=0.19

inherit perl-module

DESCRIPTION="URI::db - Database URIs"
HOMEPAGE="https://metacpan.org/pod/URI::db"

KEYWORDS="~amd64 ~x86"
#LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Module-Build
	dev-perl/URI-Nested
"

RDEPEND="
	${DEPEND}
"

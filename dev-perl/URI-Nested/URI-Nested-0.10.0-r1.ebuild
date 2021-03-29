# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DWHEELER"
DIST_VERSION=0.10

inherit perl-module

DESCRIPTION="URI::Nested - Nested URIs"
HOMEPAGE="https://metacpan.org/pod/URI::Nested"

KEYWORDS="~amd64"
#LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Module-Build
"

RDEPEND="
	${DEPEND}
"

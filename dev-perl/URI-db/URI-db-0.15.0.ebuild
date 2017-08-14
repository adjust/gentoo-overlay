# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="DWHEELER"
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="db stuff"

#LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Module-Build
	dev-perl/URI-Nested
"

DEPEND="${RDEPEND}"

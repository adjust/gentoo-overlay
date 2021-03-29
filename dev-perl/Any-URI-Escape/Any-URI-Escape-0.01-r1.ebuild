# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="PHRED"
DIST_VERSION="0.01"

inherit perl-module

DESCRIPTION="Load URI::Escape::XS preferentially over URI::Escape"
HOMEPAGE="https://metacpan.org/pod/Any::URI::Escape"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="
	dev-perl/URI
"

RDEPEND="
	${DEPEND}
"

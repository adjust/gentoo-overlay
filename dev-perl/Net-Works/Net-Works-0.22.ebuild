# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="MAXMIND"
MODULE_VERSION="0.22"

inherit perl-module

DESCRIPTION="An object representing a single IP address (4 or 6) subnet"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Moo
	>=dev-perl/namespace-autoclean-0.130.0
	dev-perl/List-AllUtils
	dev-perl/Test-Fatal
	>=dev-perl/Math-Int128-0.22
	dev-perl/Sub-Quote
	dev-lang/perl"

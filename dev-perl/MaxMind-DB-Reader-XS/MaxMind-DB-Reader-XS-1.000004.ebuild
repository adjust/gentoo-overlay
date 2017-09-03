# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="MAXMIND"
MODULE_VERSION="1.000004"

inherit perl-module

DESCRIPTION="Fast XS implementation of MaxMind DB reader"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Math-Int128
	>=dev-perl/MaxMind-DB-Common-0.040001
	dev-perl/Test-Requires
	dev-perl/Test-Number-Delta
	dev-perl/MaxMind-DB-Reader
	dev-perl/Moo
	dev-perl/Module-Implementation
	>=dev-perl/Module-Build-0.421.600
	dev-perl/Test-Fatal
	>=dev-perl/Path-Class-0.360.0
	dev-perl/namespace-autoclean
	>=dev-perl/Net-Works-0.22
	dev-libs/libmaxminddb
	dev-lang/perl"

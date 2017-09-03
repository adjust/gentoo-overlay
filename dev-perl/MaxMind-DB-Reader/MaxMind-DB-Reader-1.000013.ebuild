# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="MAXMIND"
MODULE_VERSION="1.000013"

inherit perl-module

DESCRIPTION="Read MaxMind DB files and look up IP addresses"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Module-Implementation
	dev-perl/MaxMind-DB-Common
	>=dev-perl/Path-Class-0.360.0
	dev-perl/Test-Number-Delta
	dev-perl/MooX-StrictConstructor
	dev-perl/List-AllUtils
	dev-perl/Test-Requires
	dev-perl/Test-Bits
	dev-perl/Role-Tiny
	>=dev-perl/Data-Validate-IP-0.240.0
	dev-perl/Moo
	dev-perl/namespace-autoclean
	dev-perl/DateTime
	dev-perl/Data-Printer
	dev-perl/Data-IEEE754
	dev-perl/Test-Fatal
	dev-lang/perl"

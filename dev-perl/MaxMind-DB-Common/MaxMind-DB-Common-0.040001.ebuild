# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="MAXMIND"
MODULE_VERSION="0.040001"

inherit perl-module

DESCRIPTION="Common libraries for the MaxMind db driver"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/MooX-StrictConstructor
	dev-perl/List-AllUtils
	dev-perl/Data-Dumper-Concise
	dev-perl/DateTime
	dev-perl/Sub-Quote
	dev-perl/Moo
	dev-perl/namespace-autoclean
	dev-lang/perl"

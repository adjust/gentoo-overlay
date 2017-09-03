# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="HARTZELL"
MODULE_VERSION="0.008"

inherit perl-module

DESCRIPTION="Make your Moo-based object constructors blow up on unknown attributes."

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Class-Method-Modifiers
	dev-perl/indirect
	dev-perl/Moo
	dev-perl/strictures
	dev-perl/bareword-filehandles
	dev-perl/multidimensional
	dev-perl/Pod-Coverage-TrustPod
	dev-perl/Test-Pod
	dev-perl/Test-Pod-Coverage
	dev-perl/Test-CPAN-Meta
	dev-perl/Test-Fatal
	>=dev-perl/Module-Build-0.421.600
	dev-lang/perl"

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="DROLSKY"
MODULE_VERSION="0.02"

inherit perl-module

DESCRIPTION="Provides a bits_is() subroutine for testing binary data"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/List-AllUtils
	dev-perl/Test-Fatal
	dev-lang/perl"

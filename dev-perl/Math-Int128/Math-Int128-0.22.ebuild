# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="SALVA"
MODULE_VERSION="0.22"

inherit perl-module

DESCRIPTION="Manipulate 128 bits integers in Perl"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/Math-Int64-0.54
	dev-lang/perl"

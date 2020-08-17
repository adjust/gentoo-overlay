# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="PHRED"
MODULE_VERSION="0.01"

inherit perl-module

DESCRIPTION="Load URI::Escape::XS preferentially over URI::Escape"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/URI
	dev-lang/perl"

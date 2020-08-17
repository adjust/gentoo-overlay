# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="PERLANCAR"
MODULE_VERSION="0.101"

inherit perl-module

DESCRIPTION="(DEPRECATED) Send Log::Any logs to a subroutine"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/Log-Any-1.701.0
	dev-lang/perl"

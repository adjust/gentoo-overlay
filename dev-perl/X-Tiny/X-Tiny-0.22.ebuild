# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="FELIPE"
DIST_VERSION="0.22"

inherit perl-module

DESCRIPTION="X::Tiny - A lightweight exception framework for Perl"
HOMEPAGE="https://metacpan.org/dist/X-Tiny"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Module-Runtime
"

RDEPEND="
	${DEPEND}
"

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PEVANS"
DIST_VERSION="0.14"

inherit perl-module

DESCRIPTION="Syntax::Keyword::Dynamically - Dynamically assign to an lvalue"
HOMEPAGE="https://metacpan.org/dist/Syntax-Keyword-Dynamically"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
	dev-perl/Module-Build
	dev-perl/Future-AsyncAwait
	dev-perl/XS-Parse-Keyword
"

DEPEND="
	dev-perl/XS-Parse-Keyword
"

RDEPEND="
	${DEPEND}
"

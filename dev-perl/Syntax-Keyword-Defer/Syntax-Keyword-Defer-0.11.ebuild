# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PEVANS"
DIST_VERSION="0.11"

inherit perl-module

DESCRIPTION="Syntax::Keyword::Defer - Execute code at end of scope"
HOMEPAGE="https://metacpan.org/dist/Syntax-Keyword-Defer"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
	dev-perl/Module-Build
	dev-perl/XS-Parse-Keyword
"

DEPEND="
	dev-perl/XS-Parse-Keyword
"

RDEPEND="
	${DEPEND}
"

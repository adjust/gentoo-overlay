# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PEVANS"
DIST_VERSION="0.05"

inherit perl-module

DESCRIPTION="Feature::Compat::Try - Use try/catch syntax in older Perl versions"
HOMEPAGE="https://metacpan.org/dist/Feature-Compat-Try"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
	dev-perl/Module-Build
"

DEPEND="
	dev-perl/Syntax-Keyword-Try
"

RDEPEND="
	${DEPEND}
"

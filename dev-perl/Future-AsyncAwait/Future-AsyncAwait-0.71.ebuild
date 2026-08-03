# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PEVANS"
DIST_VERSION="0.71"

inherit perl-module

DESCRIPTION="Future::AsyncAwait - Deferred subroutine syntax for futures"
HOMEPAGE="https://metacpan.org/dist/Future-AsyncAwait"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
	dev-perl/Module-Build
	dev-perl/XS-Parse-Keyword
	dev-perl/XS-Parse-Sublike
"

DEPEND="
	dev-perl/File-ShareDir
	dev-perl/Future
	dev-perl/XS-Parse-Keyword
	dev-perl/XS-Parse-Sublike
"

RDEPEND="
	${DEPEND}
"

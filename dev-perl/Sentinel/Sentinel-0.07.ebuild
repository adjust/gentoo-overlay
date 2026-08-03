# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PEVANS"
DIST_VERSION="0.07"

inherit perl-module

DESCRIPTION="Sentinel - Scalar sentinel values"
HOMEPAGE="https://metacpan.org/dist/Sentinel"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
	dev-perl/Module-Build
"

DEPEND=""

RDEPEND=""

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="CHANSEN"
DIST_VERSION="0.03"

inherit perl-module

DESCRIPTION="URL::Encode - Encoding and decoding of application/x-www-form-urlencoded"
HOMEPAGE="https://metacpan.org/dist/URL-Encode"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 )"

SLOT="0"

IUSE=""

BDEPEND="
  dev-perl/Module-Install 
"

DEPEND=""

RDEPEND=""

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DAGOLDEN"
DIST_VERSION="0.001"

inherit perl-module

DESCRIPTION="UUID::URandom - Make version 4 UUIDs using the system CSPRNG"
HOMEPAGE="https://metacpan.org/dist/UUID-URandom"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"

SLOT="0"

IUSE=""

DEPEND="
	>=dev-perl/Crypt-URandom-0.360.0
"

RDEPEND="
	${DEPEND}
"

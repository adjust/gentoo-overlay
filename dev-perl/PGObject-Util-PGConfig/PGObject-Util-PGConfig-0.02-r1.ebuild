# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="EINHVERFR"
DIST_VERSION="0.02"

inherit perl-module

DESCRIPTION="Postgres Configuration Management"
HOMEPAGE="https://metacpan.org/pod/PGObject::Util::PGConfig"

KEYWORDS="~amd64"
LICENSE="BSD"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/DBI
	dev-perl/DBD-Pg
"

RDEPEND="
	${DEPEND}
"

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="EINHVERFR"
MODULE_VERSION="0.02"

inherit perl-module

DESCRIPTION="Postgres Configuration Management"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/DBI
	dev-perl/DBD-Pg
	dev-lang/perl"

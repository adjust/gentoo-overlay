# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Run tests on an isolated, temporary PostgreSQL database"
HOMEPAGE="http://ephemeralpg.org/"
SRC_URI="${HOMEPAGE}/code/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="ISC"
SLOT="0"
IUSE="" # TODO: perl & python

DEPEND=''
RDEPEND='>=dev-db/postgresql-9.3'

S="${WORKDIR}/eradman-ephemeralpg-775e90996fea"

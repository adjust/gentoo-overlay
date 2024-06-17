# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 10 11 12 13 14 15 16 17 )
POSTGRES_USEDEP="server"

inherit git-r3 postgres-multi

DESCRIPTION="Reorganize tables in PostgreSQL databases with minimal locks"
HOMEPAGE="https://github.com/reorg/pg_repack"
EGIT_REPO_URI="https://github.com/reorg/pg_repack.git"
EGIT_COMMIT="3edf5b3df04dff792e693ff899b33de2e4fad859"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${POSTGRES_DEP}"
RDEPEND="${DEPEND}"

# Needs a running PostgreSQL server
RESTRICT="test"

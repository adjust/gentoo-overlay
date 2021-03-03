# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="EZIMUEL"
DIST_VERSION="7.711001"

inherit perl-module

DESCRIPTION="The official client for Elasticsearch"
HOMEPAGE="https://metacpan.org/pod/Search::Elasticsearch"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Module-Runtime
	dev-perl/Test-Exception
	dev-perl/Test-Pod
	dev-perl/Any-URI-Escape
	>=dev-perl/Log-Any-1.701.0
	dev-perl/IO-Socket-SSL
	dev-perl/Moo
	dev-perl/JSON-MaybeXS
	dev-perl/URI
	dev-perl/Test-SharedFork
	dev-perl/HTTP-Message
	dev-perl/Try-Tiny
	dev-perl/Sub-Exporter
	dev-perl/Devel-GlobalDestruction
	dev-perl/namespace-clean
	dev-perl/Net-IP
	>=dev-perl/Log-Any-Adapter-Callback-0.101
	dev-perl/Test-Deep
	dev-perl/libwww-perl
	>=dev-perl/Package-Stash-0.370.0
"

RDEPEND="
	${DEPEND}
"

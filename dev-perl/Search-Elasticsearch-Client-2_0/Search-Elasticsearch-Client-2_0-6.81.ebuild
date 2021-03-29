# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULE_AUTHOR="EZIMUEL"
MODULE_VERSION="6.81"

inherit perl-module

DESCRIPTION="Thin client with full support for Elasticsearch 2.x APIs"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Search-Elasticsearch
	dev-perl/Moo
	dev-perl/namespace-clean
	dev-perl/Try-Tiny
	dev-perl/Test-Deep
	>=dev-perl/Log-Any-Adapter-Callback-0.101
	dev-perl/Sub-Exporter
	dev-perl/Devel-GlobalDestruction
	dev-perl/IO-Socket-SSL
	dev-perl/Test-Exception
	dev-perl/Log-Any
"

RDEPEND="
	${DEPEND}
"

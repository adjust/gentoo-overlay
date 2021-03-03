# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="PERLANCAR"
DIST_VERSION="0.101"

inherit perl-module

DESCRIPTION="Log::Any::Adapter::Callback - (DEPRECATED) Send Log::Any logs to a subroutine"
HOMEPAGE="https://metacpan.org/pod/Log::Any::Adapter::Callback"

KEYWORDS="~amd64 ~x86"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	>=dev-perl/Log-Any-1.701.0
"

RDEPEND="
	${DEPEND}
"

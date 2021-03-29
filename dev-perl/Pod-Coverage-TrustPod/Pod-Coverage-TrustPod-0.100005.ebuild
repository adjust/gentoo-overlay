# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="RJBS"
DIST_VERSION="0.100005"

inherit perl-module

DESCRIPTION="allow a module's pod to contain Pod::Coverage hints"
HOMEPAGE="https://metacpan.org/pod/Pod::Coverage::TrustPod"

KEYWORDS="~amd64"
LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/Pod-Eventual
	dev-perl/Pod-Coverage
"

RDEPEND="
	${DEPEND}
"

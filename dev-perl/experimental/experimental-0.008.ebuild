# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
DESCRIPTION="Experimental features made easy"
HOMEPAGE="https://github.com/Leont/experimental"
SRC_URI="mirror://cpan/authors/id/L/LE/LEONT/experimental-0.008.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build >=dev-perl/Module-Build-Tiny-0.036"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

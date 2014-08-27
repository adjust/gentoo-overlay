# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
DESCRIPTION="Implement read-write timeout on Perl's file handles at the perlio level"
HOMEPAGE="https://github.com/dams/perlio-via-timeout"
SRC_URI="mirror://cpan/authors/id/D/DA/DAMS/PerlIO-via-Timeout-0.29.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/Module-Build-Tiny"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

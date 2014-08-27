# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
DESCRIPTION="Add read / write timeout to perl IO::Socket"
HOMEPAGE="https://github.com/dams/io-socket-timeout"
SRC_URI="mirror://cpan/authors/id/D/DA/DAMS/IO-Socket-Timeout-0.22.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/PerlIO-via-Timeout"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

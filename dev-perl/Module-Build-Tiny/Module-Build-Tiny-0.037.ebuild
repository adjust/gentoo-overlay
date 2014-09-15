# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
DESCRIPTION="A tiny replacement for Module::Build"
HOMEPAGE="https://github.com/Leont/module-build-tiny"
SRC_URI="mirror://cpan/authors/id/L/LE/LEONT/Module-Build-Tiny-0.037.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/ExtUtils-Config dev-perl/ExtUtils-Helpers dev-perl/ExtUtils-InstallPaths"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

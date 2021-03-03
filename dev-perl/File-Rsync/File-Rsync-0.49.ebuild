# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LEAKIN
DIST_VERSION=0.49

inherit perl-module

DESCRIPTION="perl module interface to rsync(1)"
HOMEPAGE="https://metacpan.org/pod/File::Rsync"

KEYWORDS="~amd64"
#LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0"

IUSE=""

DEPEND="
	net-misc/rsync
"

RDEPEND="
	${DEPEND}
"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LEAKIN
MODULE_VERSION=0.45
inherit perl-module

DESCRIPTION="perl module interface to rsync(1)"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-misc/rsync"

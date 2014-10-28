# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="PerlIO::via::Timeout - a PerlIO layer that adds read & write timeout to a handle"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-perl/Module-Build-Tiny
	virtual/perl-Module-Build
"

mytargets="install"

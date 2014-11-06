# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=0.27
inherit perl-module

DESCRIPTION="IO::Socket with read/write timeout"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-perl/PerlIO-via-Timeout
	virtual/perl-Module-Build
"

mytargets="install"

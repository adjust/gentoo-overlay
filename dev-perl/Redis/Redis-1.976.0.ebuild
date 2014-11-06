# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=DAMS
MODULE_VERSION=1.976
inherit perl-module

DESCRIPTION="Perl binding for Redis database"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	virtual/perl-Module-Build
	dev-perl/IO-Socket-Timeout
	dev-perl/Try-Tiny
"

mytargets="install"

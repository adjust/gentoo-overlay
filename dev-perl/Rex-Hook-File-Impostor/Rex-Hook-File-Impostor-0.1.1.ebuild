# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="FERKI"
DIST_VERSION="v${PV}"
inherit perl-module

DESCRIPTION="Execute Rex file management commands on a copy of the original file"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	test? (
		dev-perl/Test-File
		dev-perl/Test2-Suite
		virtual/perl-Carp
		virtual/perl-File-Temp
	)
"
RDEPEND=""
DEPEND="${RDEPEND}"

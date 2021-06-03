# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="ALIP"
DIST_VERSION="v${PV}"
inherit perl-module

DESCRIPTION="Rex module to support Idrac4"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-admin/rex"
DEPEND="${RDEPEND}"

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="FERKI"
DIST_VERSION="v${PV}"
inherit perl-module

DESCRIPTION="Show diff of changes for files managed by Rex"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	test? (
		dev-perl/File-Touch
		dev-perl/Test2-Suite
		dev-perl/Test-File
		dev-perl/Test-Output
	)
"
RDEPEND="
	app-admin/rex
	dev-perl/Text-Diff
"
DEPEND="${RDEPEND}"

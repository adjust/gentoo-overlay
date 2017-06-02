# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit perl-module git-2

DESCRIPTION="Module to manage ruby versions in non-interactive environments"
HOMEPAGE="https://github.com/adjust/p5-Ruby-VersionManager"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/p5-Ruby-VersionManager"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-perl/Moo
	dev-perl/YAML
	dev-perl/libwww-perl"

RDEPEND="${DEPEND}"

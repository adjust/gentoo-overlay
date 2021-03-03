# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module git-r3

DESCRIPTION="Module to manage ruby versions in non-interactive environments"
HOMEPAGE="https://github.com/adjust/p5-Ruby-VersionManager"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adjust/p5-Ruby-VersionManager"

KEYWORDS=""

IUSE=""

SLOT="0"

DEPEND="
	dev-perl/Moo
	dev-perl/YAML
	dev-perl/libwww-perl"

RDEPEND="
	${DEPEND}
"

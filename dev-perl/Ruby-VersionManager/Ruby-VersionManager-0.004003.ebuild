# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
inherit git-2

DESCRIPTION="Module to manage ruby versions in non-interactive environments"
HOMEPAGE="https://github.com/adjust/p5-Ruby-VersionManager"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adeven/p5-Ruby-VersionManager"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Moo dev-perl/yaml dev-perl/libwww-perl"

RDEPEND="${DEPEND}"

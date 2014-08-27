# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit perl-module
inherit git-2

DESCRIPTION="Gentoo abstraction layer for automation with perl scripts"
HOMEPAGE="https://github.com/adjust/imp"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adeven/imp.git"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	virtual/perl-Module-Build
	dev-perl/Moo
	dev-perl/yaml
	dev-perl/JSON
	dev-perl/Template-Toolkit"

RDEPEND="${DEPEND}"

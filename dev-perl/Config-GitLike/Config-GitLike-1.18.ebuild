# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="ALEXMV"
DIST_VERSION=1.18

inherit perl-module

DESCRIPTION="Config::GitLike - git-compatible config file parsing"
HOMEPAGE="https://metacpan.org/pod/Config::GitLike"

KEYWORDS="~amd64"
#LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0"

IUSE=""

RDEPEND="
	dev-perl/Any-Moose
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"

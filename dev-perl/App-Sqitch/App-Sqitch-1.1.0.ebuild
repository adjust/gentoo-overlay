# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR="DWHEELER"
DIST_VERSION=v1.1.0

inherit perl-module

DESCRIPTION="App::Sqitch - Sensible database change management"
HOMEPAGE="https://metacpan.org/pod/App::Sqitch"

KEYWORDS="~amd64 ~x86"
#LICENSE="|| ( Artistic GPL-1+ )"

SLOT="0"

IUSE=""

DEPEND="
	dev-perl/File-HomeDir
	dev-perl/DBD-Pg
	dev-perl/Module-Build
	dev-perl/Moo
	dev-perl/Config-GitLike
	dev-perl/Type-Tiny
	dev-perl/Throwable
	dev-perl/MooX-Types-MooseLike
	dev-perl/IPC-System-Simple
	dev-perl/namespace-autoclean
	dev-perl/Path-Class
	dev-perl/Hash-Merge
	dev-perl/Exporter-Tiny
	dev-perl/IO-Pager
	dev-perl/IPC-Run3
	dev-perl/PerlIO-utf8_strict
	dev-perl/String-Formatter
	dev-perl/String-ShellQuote
	dev-perl/Template-Tiny
	dev-perl/URI-db
"

RDEPEND="
	${DEPEND}
"

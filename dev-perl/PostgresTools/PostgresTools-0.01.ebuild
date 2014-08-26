EAPI=5
inherit perl-module
inherit git-2

DESCRIPTION=""
HOMEPAGE="https://github.com/adjust/postgres_tools"
SRC_URI=""
EGIT_REPO_URI="https://github.com/adeven/postgres_tools.git"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/Moo dev-perl/DBD-Pg perl-core/File-Path dev-perl/DateTime dev-perl/DateTime-Format-Strptime dev-perl/Parallel-ForkManager dev-perl/Term-ProgressBar"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

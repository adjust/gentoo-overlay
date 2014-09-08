EAPI=5
inherit perl-module
DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://search.cpan.org/CPAN/authors/id/L/LE/LEONT/Module-Build-Tiny-0.037.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/ExtUtils-Config dev-perl/ExtUtils-Helpers dev-perl/ExtUtils-InstallPaths"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

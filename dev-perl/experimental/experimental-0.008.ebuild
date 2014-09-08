EAPI=5
inherit perl-module
DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://search.cpan.org/CPAN/authors/id/L/LE/LEONT/experimental-0.008.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build >=dev-perl/Module-Build-Tiny-0.036"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

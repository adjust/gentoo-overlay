EAPI=5
inherit perl-module
DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DA/DAMS/IO-Socket-Timeout-0.22.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/PerlIO-via-Timeout"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

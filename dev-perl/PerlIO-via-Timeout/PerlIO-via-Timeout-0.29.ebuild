EAPI=5
inherit perl-module
DESCRIPTION=""
HOMEPAGE=""
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DA/DAMS/PerlIO-via-Timeout-0.29.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

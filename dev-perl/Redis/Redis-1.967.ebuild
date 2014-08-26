EAPI=5
inherit perl-module
DESCRIPTION=""
HOMEPAGE="https://github.com/PerlRedis/perl-redis"
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DA/DAMS/Redis-1.967.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Module-Build dev-perl/Module-Build-Tiny dev-perl/IO-Socket-Timeout dev-perl/Try-Tiny"

RDEPEND="${DEPEND}"

src_install() {
	./Build install
}

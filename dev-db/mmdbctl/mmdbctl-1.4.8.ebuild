EAPI=8
inherit go-module

DESCRIPTION="Command-line tool for working with MaxMind DBs"
HOMEPAGE="https://github.com/ipinfo/mmdbctl"
SRC_URI="https://github.com/ipinfo/mmdbctl/archive/refs/tags/${P}.tar.gz -> ${P}.tar.gz
https://files.adjust.com/${P}.tar.xz -> ${P}-deps.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE=""

S="${WORKDIR}/mmdbctl-${P}"

DEPEND="dev-lang/go"
BDEPEND="${DEPEND}"

src_compile() {
	ego build -o mmdbctl
}

src_install() {
    dobin mmdbctl
}

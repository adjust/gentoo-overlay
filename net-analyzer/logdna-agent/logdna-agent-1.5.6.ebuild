# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LogDNA's collector agent which streams log files to your LogDNA account."
HOMEPAGE="https://github.com/logdna/logdna-agent"
SRC_URI="https://github.com/logdna/logdna-agent/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/nodejs"
RDEPEND="${DEPEND}"

DOCS=( README.md )

src_compile() {
	npm install || die "npm install failed"
	cp -p scripts/openrc-init scripts/logdna-agent || die "cp failed"
}

src_install() {
	dodir logdna-agent
	into usr/$(get_libdir)/logdna-agent

	insinto usr/$(get_libdir)/logdna-agent
	doins -r lib
	doins -r node_modules
	doins index.js
	doins package.json

	doinitd scripts/logdna-agent

	dobin "${FILESDIR}"/logdna-agent
	sed -e "s/@LIBDIR@/$(get_libdir)/" < "${FILESDIR}"/99logdna-agent > 99logdna-agent || die "sed failed"
	doenvd 99logdna-agent

	dosym "${ED%/}"/usr/$(get_libdir)/logdna-agent/bin/logdna-agent /usr/bin/logdna-agent
}

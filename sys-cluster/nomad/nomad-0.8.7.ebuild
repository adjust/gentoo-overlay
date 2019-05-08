# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-vcs-snapshot golang-build user

KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/${PN}"
DESCRIPTION="The cluster manager from Hashicorp"
HOMEPAGE="http://www.nomadproject.io"
SRC_URI="https://github.com/hashicorp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
IUSE=""

RESTRICT="strip test"

DEPEND="
	dev-go/gox
	dev-lang/go
	dev-go/go-tools
	dev-go/go-crypto
	dev-go/go-net
	"
RDEPEND=""

pkg_setup() {
	enewgroup ${PN}
	enewuser  ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_prepare() {
	eapply_user

	rm -rf "${S}/src/github.com/hashicorp/nomad/vendor/golang.org/x/"{crypto,net}

	sed -e 's@^\(GIT_DESCRIBE :=\).*@\1'${PV}'@' \
		-e 's@^\(GIT_COMMIT :=\).*@\1@' \
		-e 's@^\(GIT_DIRTY :=\).*@\1@' \
		-e 's@go get -u -v $(GOTOOLS)@@' \
		-e 's@ vendorfmt @@' \
		-i "${S}/src/${EGO_PN}/GNUmakefile" || die
}

src_compile() { 
        use ui && EGO_BUILD_FLAGS="-tags 'ui'"
        golang-build_src_compile 
}

#src_compile() {
#	# The dev target sets causes build.sh to set appropriate XC_OS
#	# and XC_ARCH, and skips generation of an unused zip file,
#	# avoiding a dependency on app-arch/zip.
#	GOPATH="${S}" \
#		emake -C "${S}/src/${EGO_PN}" pkg/linux_amd64$(use lxc && echo '-lxc')/${PN}
#}

src_install() {
	local x

	#dobin "${S}/src/${EGO_PN}/pkg/linux_amd64$(use lxc && echo '-lxc')/${PN}"
	dobin "${S}/nomad" || die

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners ${PN}:${PN} "${x}"
	done

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}

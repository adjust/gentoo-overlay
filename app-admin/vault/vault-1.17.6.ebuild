# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps go-module systemd

DESCRIPTION="A tool for managing secrets"
HOMEPAGE="https://vaultproject.io/"

SRC_URI="https://github.com/hashicorp/vault/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BUSL-1.1 MPL-2.0"
LICENSE+=" Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"
IUSE=""

BDEPEND="
	dev-go/gox
	dev-go/enumer
	app-arch/zip
	>=dev-lang/go-1.21"

COMMON_DEPEND="
	acct-group/vault
	acct-user/vault"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

FILECAPS=(
	-m 755 'cap_ipc_lock=+ep' usr/bin/${PN}
)

RESTRICT="test"

src_prepare() {
	default
	# Avoid the need to have a git checkout
	sed -e 's:^\(GIT_COMMIT=\).*:\1:' \
		-e 's:^\(GIT_DIRTY=\).*:\1:' \
		-e s:\'\${GIT_COMMIT}\${GIT_DIRTY}\':: \
		-e "s|^BUILD_DATE=.*|BUILD_DATE=$(date +%Y-%m-%dT%H:%M:%SZ)|" \
		-i scripts/build.sh || die
	sed -e "/hooks/d" \
		-e 's|^\([[:space:]]*\)goimports .*)|\1true|' \
		-e "s/gofumpt/gofmt/g" \
		-i Makefile || die
	if [[ -d "${WORKDIR}/http/web_ui" ]]; then
		rm -rf "${S}/http/web_ui" || die
		mv "${WORKDIR}/http/web_ui" "${S}/http/web_ui" ||
			die "mv failed"
	else
		mkdir -p "${S}/http/web_ui" || die
		touch "${S}/http/web_ui/no_web_ui" || die
	fi
}

src_compile() {
	mkdir "${T}"/bin || die
	GOPATH="${T}" \
	XC_ARCH=$(go env GOARCH) \
	XC_OS=$(go env GOOS) \
	XC_OSARCH=$(go env GOOS)/$(go env GOARCH) \
	emake bin
}

src_install() {
	dobin bin/${PN}
	dodoc CHANGELOG.md CONTRIBUTING.md README.md
	insinto /etc/${PN}.d
	doins "${FILESDIR}/"*.json.example
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Amazon AWS Command Line Interface v2 (official prebuilt binary)"
HOMEPAGE="https://aws.amazon.com/cli/"
SRC_URI="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="strip mirror"

DEPEND=""
RDEPEND="
	sys-libs/glibc
"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack "${P}.zip"
}

src_install() {
	# Install into image directory (NO sudo)
	mkdir -p "${D}/usr/local/aws-cli" || die
	mkdir -p "${D}/usr/local/bin" || die

	# Run upstream installer into DESTDIR
	./aws/install \
		--bin-dir "${D}/usr/local/bin" \
		--install-dir "${D}/usr/local/aws-cli" \
		--update || die

	# Fix permissions
	fperms -R a+rX /usr/local/aws-cli
	fperms a+rx /usr/local/bin/aws
}

pkg_postinst() {
	elog "AWS CLI v2 installed."
	elog "Binary: /usr/local/bin/aws"
	elog "Install dir: /usr/local/aws-cli"
}

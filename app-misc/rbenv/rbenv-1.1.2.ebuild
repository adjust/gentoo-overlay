# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GIT_REVISION=a3fa9b7

inherit multilib bash-completion-r1

DESCRIPTION="Ruby Version Manager"
HOMEPAGE="https://github.com/rbenv/rbenv"
SRC_URI="https://github.com/${PN}/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${PN}-${GIT_REVISION}"

# TODO: compile the bash extension, quoting README.md:
# Optionally, try to compile dynamic bash extension to speed up rbenv. Don't worry if it fails; rbenv will still work normally:
# $ cd ~/.rbenv && src/configure && make -C src

src_install() {
		for dir in /usr/{bin,$(get_libdir)/${PN}/libexec}; do
			dodir ${dir}
		done
		dosym ../$(get_libdir)/${PN}/libexec/${PN} /usr/bin/${PN}

		exeinto /usr/$(get_libdir)/${PN}/libexec
		doexe libexec/*

		dodoc README.md
		newbashcomp completions/${PN}.bash ${PN}
}

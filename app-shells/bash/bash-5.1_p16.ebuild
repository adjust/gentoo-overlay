# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GLIBC_VER="2.27"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
SRC_URI="https://files.adjust.com/${PF}.tbz2"
LICENSE="GPL-3 MIT LGPL-2.1+ BSD HPND ISC inner-net rc PCRE"
SLOT="0"
KEYWORDS="~amd64 ~amd64-prefix"
IUSE="+afs bashlogger +examples +mem-scramble +net +nls +plugins +readline +static"
RESTRICT="mirror strip"

RDEPEND="app-shells/bash[static]"

QA_PREBUILT="*"
S="${WORKDIR}"

src_prepare() {
	find usr/share/{doc,info,man} -type f -name "*.bz2" -exec bunzip2 {} +
	unlink usr/share/doc/"${PF}"/ChangeLog
}

src_install() {
        mv -t "${ED}" * || die
}

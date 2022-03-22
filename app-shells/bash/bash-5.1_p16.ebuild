# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs prefix unpacker

# Official patchlevel
# See ftp://ftp.cwru.edu/pub/bash/bash-5.1-patches/
PLEVEL="${PV##*_p}"
MY_PV="${PV/_p*}"
MY_PV="${MY_PV/_/-}"
MY_P="${PN}-${MY_PV}"
is_release() {
	case ${PV} in
	*_alpha*|*_beta*|*_rc*) return 1 ;;
	*) return 0 ;;
	esac
}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	local opt=${1} plevel=${2:-${PLEVEL}} pn=${3:-${PN}} pv=${4:-${MY_PV}}
	[[ ${plevel} -eq 0 ]] && return 1
	eval set -- {1..${plevel}}
	set -- $(printf "${pn}${pv/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		local u
		for u in mirror://gnu/${pn} ftp://ftp.cwru.edu/pub/bash ; do
			printf "${u}/${pn}-${pv}-patches/%s " "$@"
		done
	fi
}

# The version of readline this bash normally ships with.
READLINE_VER="8.1"

DESCRIPTION="The standard GNU Bourne again shell"
HOMEPAGE="http://tiswww.case.edu/php/chet/bash/bashtop.html"
if is_release ; then
	SRC_URI="mirror://gnu/bash/${MY_P}.tar.gz $(patches)"
else
	SRC_URI="ftp://ftp.cwru.edu/pub/bash/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
[[ "${PV}" == *_rc* ]] || \
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="afs bashlogger examples mem-scramble +net nls plugins +readline"

DEPEND="
	>=sys-libs/ncurses-5.2-r2:0=
	nls? ( virtual/libintl )
	readline? ( >=sys-libs/readline-${READLINE_VER}:0= )
"
RDEPEND="app-shells/bash[static]"
# We only need yacc when the .y files get patched (bash42-005, bash51-011)
BDEPEND="virtual/yacc"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Patches from Chet sent to bashbug ml
	"${FILESDIR}"/${PN}-5.0-syslog-history-extern.patch
)

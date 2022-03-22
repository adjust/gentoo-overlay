# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker

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

RDEPEND="app-shells/bash[static]"

S="${WORKDIR}"

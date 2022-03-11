# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.6 10 11 12 13 14 )
POSTGRES_USEDEP="bagger"
BUILD_DIR="${S}/sql/bagger_data"

inherit postgres-multi vcs-snapshot

DESCRIPTION="adjust bagger data trigger"
HOMEPAGE="https://github.com/adjust/bagger"
# We do this package name dance to reuse the tarball from bagger-tools
SRC_URI="https://github.com/adjust/bagger/archive/v${PV}.tar.gz -> bagger-tools-${PV}.tar.gz"

LICENSE="Unlicense"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

DEPEND=""

RDEPEND="
	${DEPEND}
	${POSTGRES_DEP}
"

pkg_nofetch() {
	[ -z "${SRC_URI}" ] && return

	# May I have your attention please
	einfo "**************************"
	einfo "Please manually download"
	einfo "$SRC_URI"
	einfo "and put it on binhost"
	einfo "**************************"
}

src_unpack() {
	default
	mv "${WORKDIR}/bagger-${PV}-r1" "${WORKDIR}/${P}" \
		|| die "Renaming src dir failed"
}

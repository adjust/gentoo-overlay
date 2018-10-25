# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
POSTGRES_COMPAT=( "9.6" "10" )
POSTGRES_USEDEP="bagger"
BUILD_DIR="${S}/sql/bagger_data"
inherit postgres-multi

DESCRIPTION="adjust bagger data trigger"
HOMEPAGE="https://github.com/adjust/bagger"
SLOT="0"
IUSE=""

LICENSE="Unlicense"

if [[ ${PV} == 9999 ]]
then
	inherit git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/adjust/bagger.git"
else
	inherit vcs-snapshot
	# We do this package name dance to
	# reuse the tarball from bagger-tools
	SRC_URI="https://github.com/adjust/bagger/archive/v${PVR}.tar.gz -> bagger-tools-${PVR}.tar.gz"
	KEYWORDS="~amd64"
fi

DEPEND=""

RDEPEND="${DEPEND}
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
	[ -z "${SRC_URI}" ] && \
		git-r3_src_unpack && \
		return

	default
	mv "${WORKDIR}/bagger-${PVR}" "${WORKDIR}/${P}" \
		|| die "Renaming src dir failed"
}

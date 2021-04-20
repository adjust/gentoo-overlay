# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( "10" "11" "12")

#POSTGRES_USEDEP="bagger"
#BUILD_DIR="${S}/sql/bagger_data"

inherit postgres-multi vcs-snapshot

DESCRIPTION="adjust bagger json exports extension"
HOMEPAGE="https://github.com/adjust/bagger_exports"

# We do this package name dance to reuse the tarball from bagger-tools
SRC_URI="https://github.com/adjust/bagger_exports/archive/v${PV}.tar.gz -> bagger-exports-${PV}.tar.gz"

LICENSE="Unlicense"
KEYWORDS="~amd64"

SLOT="0"

IUSE="+schaufel"

LICENSE="Unlicense"

DEPEND="
"

RDEPEND="
	${DEPEND}
	${POSTGRES_DEP}
	schaufel? (
		>=app-admin/schaufel-0.7
	)
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
	mv "${WORKDIR}/bagger_exports-${PV}" "${WORKDIR}/${P}" \
		|| die "Renaming src dir failed"
}

src_install() {
	default
	dobin "${WORKDIR}/${P}/scripts/"*
}

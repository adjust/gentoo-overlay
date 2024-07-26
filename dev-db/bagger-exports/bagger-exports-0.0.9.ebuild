# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( "10" "11" "12")

inherit postgres-multi vcs-snapshot

DESCRIPTION="adjust bagger json exports extension"
HOMEPAGE="https://github.com/adjust/bagger_exports"

# We do this package name dance to reuse the tarball from bagger-tools
SRC_URI="https://github.com/adjust/bagger_exports/archive/v${PV}.tar.gz -> bagger-exports-${PV}.tar.gz"

LICENSE="Unlicense"
KEYWORDS="~amd64"

SLOT="0"

IUSE="+schaufel"
RESTRICT="bindist fetch"
LICENSE="Unlicense"

DEPEND="
"

RDEPEND="
	${DEPEND}
	${POSTGRES_DEP}
	schaufel? (
		>=app-admin/schaufel-0.9
	)
	>=dev-lang/perl-5.26
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
	postgres-multi_src_install
	dobin "${WORKDIR}/${P}/scripts/"*
}

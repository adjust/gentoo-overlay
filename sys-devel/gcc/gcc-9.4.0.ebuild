# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TOOLCHAIN_PATCH_DEV="slyfox"
PATCH_VER="1"
MUSL_VER="1"

inherit toolchain

KEYWORDS="amd64"
RESTRICT="bindist fetch"

RDEPEND=""
DEPEND="
	${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.13 )
	>=${CATEGORY}/binutils-2.20"

if [[ ${CATEGORY} != cross-* ]]; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.13 )"
fi

MY_SRC_URI=(
	gcc-9.4.0-musl-patches-1.tar.bz2
	gcc-9.4.0-patches-1.tar.bz2
	gcc-9.4.0.tar.xz
)

pkg_nofetch() {
	einfo "Please manually download the following archives:"
	for u in "${MY_SRC_URI[@]}"; do
		einfo "https://files.adjust.com/$u";
	done
	einfo "Put them in /var/cache/distfiles and rerun this ebuild."
}

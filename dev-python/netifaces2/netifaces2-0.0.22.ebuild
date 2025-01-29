# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.2
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	indoc@1.0.7
	libc@0.2.153
	lock_api@0.4.9
	log@0.4.20
	memoffset@0.6.5
	memoffset@0.9.0
	nix@0.28.0
	once_cell@1.15.0
	parking_lot@0.12.1
	parking_lot_core@0.9.3
	proc-macro2@1.0.70
	pyo3-build-config@0.17.2
	pyo3-ffi@0.17.2
	pyo3-macros-backend@0.17.2
	pyo3-macros@0.17.2
	pyo3@0.17.2
	quote@1.0.33
	redox_syscall@0.2.16
	scopeguard@1.1.0
	smallvec@1.10.0
	syn@1.0.102
	syn@2.0.41
	target-lexicon@0.12.4
	thiserror-impl@1.0.51
	thiserror@1.0.51
	unicode-ident@1.0.5
	unindent@0.1.10
	windows-sys@0.36.1
	windows@0.42.0
	windows_aarch64_gnullvm@0.42.0
	windows_aarch64_msvc@0.36.1
	windows_aarch64_msvc@0.42.0
	windows_i686_gnu@0.36.1
	windows_i686_gnu@0.42.0
	windows_i686_msvc@0.36.1
	windows_i686_msvc@0.42.0
	windows_x86_64_gnu@0.36.1
	windows_x86_64_gnu@0.42.0
	windows_x86_64_gnullvm@0.42.0
	windows_x86_64_msvc@0.36.1
	windows_x86_64_msvc@0.42.0
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{8..12} )

inherit cargo distutils-r1 pypi

DESCRIPTION="Implement minicmal boilerplate CLIs derived from type hints and parse from command line, config files and environment variables."
HOMEPAGE="https://github.com/SamuelYvon/netifaces-2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

SRC_URI+="
	${CARGO_CRATE_URIS}
"

RDEPEND="
	${PYTHON_DEPS}
"

BDEPEND="
	${RDEPEND}
	>=dev-util/maturin-1.4.0
"

src_unpack() {
	default_src_unpack
	mv "${WORKDIR}/netifaces-2-${PV}" "${S}"
	cargo_src_unpack
}

src_prepare() {
	distutils-r1_src_prepare
}

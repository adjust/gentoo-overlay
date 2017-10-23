# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 bash-completion-r1

HOMEPAGE='https://cloud.google.com/sdk'
DESCRIPTION="API Client library for Google Cloud"
SLOT="0"
SRC_URI="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${P}-linux-x86_64.tar.gz"

LICENSE='Apache-2.0'
SLOT='0'
KEYWORDS='~amd64'

IUSE='bash-completion zsh-completion'

DEPEND="${PYTHON_DEPS}
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/crcmod[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	!net-misc/gsutil
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${PN}"

src_prepare() {
	# TODO: Drop bundled bloat.
	# Needs more ebuilds for dependencies.
	# find . -depth -type d -name third_party -exec rm -fr '{}' \;
	rm -fr lib/third_party/{argcomplete,chardet,crcmod,crcmod_osx,httplib2}
	# Same bloat is under platform/gsutil, but google argues against it:
	# `gsutil command cannot work properly when installed this way.'
	# So we just drop py3 bits for now (py2 is a hard dep ^^).
	rm -fr platform/gsutil/third_party/httplib2/python3

	# sing a song for python eclass.
	find . -type f -name '*.py' -exec sed -i -e '1s|^#!.*python2.[0-4]$|#!'${EPYTHON}'|' '{}' \;
	find . -type f -name '*.[co]' -delete
	python_fix_shebang --force .

	default
}

src_install() {
	local my_d=/opt/${PN}

	dobin "${FILESDIR}/"{gcloud,gsutil}

	insinto "${my_d}"
	doins -r lib platform "${FILESDIR}/properties"

	if use bash-completion; then
		newbashcomp completion.bash.inc ${PN}
		bashcomp_alias gcloud gsutil
	fi
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		newins completion.zsh.inc _${PN}
	fi

	python_optimize "${ED%/}${my_d}"
}

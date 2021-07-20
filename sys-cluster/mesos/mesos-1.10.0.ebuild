# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools java-pkg-opt-2 python-any-r1 toolchain-funcs user

DESCRIPTION="Apache Mesos is a computer cluster manager"
HOMEPAGE="https://mesos.apache.org"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"
IUSE="master agent"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	${PYTHON_DEPS}
	>=virtual/jdk-1.8
	dev-java/maven-bin:3.8
	sys-devel/gcc:9.3.0
	dev-libs/cyrus-sasl
	dev-vcs/subversion
	dev-python/six
	net-misc/curl
	sys-libs/zlib
	dev-libs/apr"

DOCS=( LICENSE README.md NOTICE )

RESTRICT="test"

pkg_setup() {
	python-any-r1_pkg_setup
	java-pkg-opt-2_pkg_setup

	# The user account "warden" is used across all Mesos/Spark/Chronos services
	# to keep the whole user account management consistent across the cluster
	# and to avoid running into user permission errors.
	enewgroup warden
	enewuser warden -1 -1 /var/lib/warden warden
}

src_prepare() {
	default

	eautoreconf
}

src_compile() {
	# just so that these variables are set up throughout the whole process.
	export CC="$(tc-getCC)" CXX="$(tc-getCXX)"

	# make will fail on:
	# src/core/lib/gpr/log_linux.cc:42:13: error: ambiguating new declaration
	# of ‘long int gettid()’
	make -j64

	# fix this problem.
	eapply "${FILESDIR}/${P}-gettid-log_linux.cc.patch"
	# useless parens causing a build failure. remove them.
	eapply "${FILESDIR}/${P}-boost-assert.hpp.patch"
	# set the maven m2 directory location to S.
	eapply "${FILESDIR}/${P}-maven-m2-directory-location.patch"

	# let's restart the compilation process.
	emake
}

src_install() {
	emake DESTDIR="${D}" install

	# suppress a QA warning wrt non-compiled pyo.
	# compile those files.
	python_optimize

	# Install Mesos initd and confd files.
	if use master; then
		newinitd "${FILESDIR}/mesos-master.initd" "mesos-master"
		newconfd "${FILESDIR}/mesos-master.confd" "mesos-master"
	fi
	if use agent; then
		newinitd "${FILESDIR}/mesos-agent.initd" "mesos-agent"
		newconfd "${FILESDIR}/mesos-agent.confd" "mesos-agent"
	fi

	local x
	for x in /var/{lib,log}/warden; do
		keepdir "${x}"
		fowners warden:warden "${x}"
	done

	einstalldocs
}

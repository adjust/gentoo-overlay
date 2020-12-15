# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Apache Hadoop project develops open-source software distributed computing."
HOMEPAGE="https://hadoop.apache.org/"
SRC_URI="https://archive.apache.org/dist/hadoop/common/${MY_P}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/openssl-compat:1.0.0
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8"

S="${WORKDIR}/${MY_P}"

DOCS=( NOTICE.txt README.txt )

src_compile() { :; }

src_install() {
	dodir "opt/${MY_PN}"
	into "opt/${MY_PN}"
	dobin bin/container-executor \
		bin/test-container-executor \
		bin/hadoop \
		bin/hdfs \
		bin/mapred \
		bin/yarn

	dosbin sbin/distribute-exclude.sh \
		sbin/mr-jobhistory-daemon.sh \
		sbin/start-dfs.sh \
		sbin/stop-balancer.sh \
		sbin/refresh-namenodes.sh \
		sbin/start-secure-dns.sh \
		sbin/yarn-daemon.sh \
		sbin/hadoop-daemon.sh \
		sbin/stop-dfs.sh \
		sbin/yarn-daemons.sh \
		sbin/hadoop-daemons.sh \
		sbin/start-all.sh \
		sbin/start-yarn.sh \
		sbin/stop-secure-dns.sh \
		sbin/httpfs.sh \
		sbin/start-balancer.sh \
		sbin/kms.sh \
		sbin/stop-all.sh \
		sbin/stop-yarn.sh

	insinto opt/${MY_PN}
	doins -r etc
	doins -r include
	doins -r lib
	doins -r libexec
	doins -r share

	doenvd "${FILESDIR}"/99hadoop
	einstalldocs
}

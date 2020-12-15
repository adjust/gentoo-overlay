# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-opt-2 user

DESCRIPTION="Lightning-fast unified analytics engine"
HOMEPAGE="https://spark.apache.org"
SRC_URI="
	!scala212? ( scala211? ( mirror://apache/spark/spark-${PV}/spark-${PV}-bin-without-hadoop.tgz -> ${P}-nohadoop-scala211.tgz ) )
	!scala211? ( scala212? ( mirror://apache/spark/spark-${PV}/spark-${PV}-bin-without-hadoop-scala-2.12.tgz -> ${P}-nohadoop-scala212.tgz ) )
"

REQUIRED_USE="^^ ( scala211 scala212 )"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64"

IUSE="scala211 +scala212"

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8"

DOCS=( LICENSE NOTICE README.md RELEASE )

pkg_setup() {
	java-pkg-opt-2_pkg_setup

	# The user account "warden" is used across all Mesos/Spark/Chronos services
	# to keep the whole user account management consistent across the cluster
	# and to avoid running into user permission errors.
	enewgroup warden
	enewuser warden -1 -1 /var/lib/warden warden
}

src_unpack() {
	unpack ${A}
	use scala211 && S="${WORKDIR}/spark-${PV}-bin-without-hadoop"
	use scala212 && S="${WORKDIR}/spark-${PV}-bin-without-hadoop-scala-2.12"
}

# Nothing to compile here.
src_compile() { :; }

src_install() {
	dodir opt/spark-${SLOT}
	into opt/spark-${SLOT}

	local SPARK_SCRIPTS=(
		bin/beeline
		bin/find-spark-home
		bin/load-spark-env.sh
		bin/pyspark
		bin/spark-class
		bin/spark-shell
		bin/spark-sql
		bin/spark-submit
	)

	local s
	for s in "${SPARK_SCRIPTS[@]}"; do
		ebegin "Setting SPARK_HOME to /opt/spark-${SLOT} in $(basename ${s}) script ..."
		sed -i -e "2iSPARK_HOME=/opt/spark-${SLOT}" "${s}"
		eend $?
		dobin "${s}"
	done

	insinto opt/spark-${SLOT}

	local SPARK_DIRS=( conf jars python sbin yarn )

	local d
	for d in "${SPARK_DIRS[@]}"; do
		doins -r "${d}"
	done

	local x
	for x in /var/{lib,log}/warden; do
		keepdir "${x}"
		fowners warden:warden "${x}"
	done

	# Spark Mesos Cluster Dispatcher init.d/conf.d files.
	newinitd "${FILESDIR}/spark-mcd.initd" spark-mcd
	newconfd "${FILESDIR}/spark-mcd.confd" spark-mcd

	# Spark History server init.d/conf.d files.
	newinitd "${FILESDIR}/spark-history.initd" spark-history
	newconfd "${FILESDIR}/spark-history.confd" spark-history

	einstalldocs
}

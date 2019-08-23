# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2

DESCRIPTION="Lightning-fast unified analytics engine (Nomad fork)"
HOMEPAGE="https://github.com/hashicorp/nomad-spark"
SRC_URI="
	!scala212? ( scala211? ( https://github.com/hashicorp/nomad-spark/releases/download/v2.4.3.0/spark-2.4.3-bin-nomad-0.tgz -> ${P}-2.11.tgz ) )
	!scala211? ( scala212? ( https://github.com/hashicorp/nomad-spark/releases/download/v2.4.3.0/spark-2.4.3-bin-nomad-0_2.12.tgz -> ${P}-2.12.tgz ) )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/jre-1.8
	!!sys-cluster/spark-bin
"

DEPEND="
	>=virtual/jdk-1.8
"

S="${WORKDIR}/spark-${PV}-bin-nomad-0"

DOCS=( LICENSE NOTICE README.md RELEASE )

IUSE="+scala211 scala212"

src_unpack() {
	unpack ${A}
	use scala212 && mv "${WORKDIR}/spark-${PV}-bin-nomad-0_2.12" "${S}" || die
}

# Nothing to compile here.
src_compile() { :; }

src_install() {
	dodir usr/lib/spark
	into usr/lib/spark

	dobin bin/beeline \
		bin/find-spark-home \
		bin/pyspark \
		bin/spark-class \
		bin/spark-shell \
		bin/spark-sql \
		bin/spark-submit
		bin/sparkR

	insinto usr/lib/spark/bin
	doins bin/load-spark-env.sh

	insinto usr/lib/spark
	doins -r conf
	doins -r data
	doins -r jars
	doins -r python
	doins -r R
	doins -r sbin

	dosym "${ED%/}"/usr/lib/spark/bin/beeline /usr/bin/beeline
	dosym "${ED%/}"/usr/lib/spark/bin/pyspark /usr/bin/pyspark
	dosym "${ED%/}"/usr/lib/spark/bin/pyspark /usr/bin/find-spark-home
	dosym "${ED%/}"/usr/lib/spark/bin/spark-class /usr/bin/spark-class
	dosym "${ED%/}"/usr/lib/spark/bin/spark-shell /usr/bin/spark-shell
	dosym "${ED%/}"/usr/lib/spark/bin/spark-sql /usr/bin/spark-sql
	dosym "${ED%/}"/usr/lib/spark/bin/spark-submit /usr/bin/spark-submit
	dosym "${ED%/}"/usr/lib/spark/bin/sparkR /usr/bin/sparkR

	doenvd "${FILESDIR}"/99spark
	einstalldocs
}

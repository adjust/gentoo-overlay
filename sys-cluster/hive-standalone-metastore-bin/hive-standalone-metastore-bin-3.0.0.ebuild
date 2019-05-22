# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user java-pkg-2

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}-bin"

DESCRIPTION="Apache Hive is a data warehouse software project."
HOMEPAGE="https://hive.apache.org/"
SRC_URI="https://www-eu.apache.org/dist/hive/${MY_PN}-${PV}/${MY_P}.tar.gz http://central.maven.org/maven2/org/apache/logging/log4j/log4j-web/2.11.2/log4j-web-2.11.2.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=virtual/jre-1.8
	~sys-cluster/hadoop-bin-3.2.0
"
DEPEND="
	~sys-cluster/hadoop-bin-3.2.0
"

S="${WORKDIR}/apache-hive-metastore-${PV}-bin"

DOCS=(NOTICE)

HIVE_USER=hive-metastore

pkg_setup() {
	enewgroup ${HIVE_USER}
	enewuser ${HIVE_USER} -1 -1 /var/lib/${HIVE_USER} ${HIVE_USER}
}

src_unpack() {
	unpack "${MY_P}.tar.gz"
	cp -v "${DISTDIR}/log4j-web-2.11.2.jar" "${S}/lib/log4j-web-2.11.2.jar" || die
	cp -v "${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-3.2.0.jar" "${S}/lib/hadoop-aws-3.2.0.jar" || die
	cp -v "${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar" "${S}/lib/aws-java-sdk-bundle-1.11.375.jar" || die
}

src_compile() { :; }

src_install() {
	dodir "opt/${MY_PN}"
	into "opt/${MY_PN}"
	dobin bin/base \
		bin/metastore-config.sh \
		bin/schematool \
		bin/start-metastore

	insinto "opt/${MY_PN}"
	doins -r conf
	doins -r lib
	doins -r scripts

	insinto "opt/${MY_PN}/bin"
	doins -r bin/ext

	keepdir /var/log/"${HIVE_USER}"
        fowners -R "${HIVE_USER}:${HIVE_USER}" /var/log/"${HIVE_USER}"

	newinitd "${FILESDIR}"/hive-metastore.initd "${HIVE_USER}"
	doenvd "${FILESDIR}"/99metastore
	einstalldocs
}

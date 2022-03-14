# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAR_NAME="jmx_prometheus_javaagent"
JAR_FILE="${JAR_NAME}-${PV}.jar"

DESCRIPTION="A process for exposing JMX Beans via HTTP for Prometheus consumption"
HOMEPAGE="https://github.com/prometheus/jmx_exporter"
SRC_URI="https://repo1.maven.org/maven2/io/prometheus/jmx/${JAR_NAME}/${PV}/${JAR_FILE}"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	virtual/jdk
"
DEPEND="
	${RDEPEND}
"

src_unpack() {

	mkdir "${WORKDIR}"/${P} || die "failed to create ${S}"
	cp -a "${DISTDIR}"/${JAR_FILE} "${S}" || die "failed to move ${JAR_FILE} to ${S}"
}

src_install() {
	INSTALL_DIR="/opt/${PN}"
	CONFIG_DIR="${INSTALL_DIR}/etc/${PN}"

	insinto "${INSTALL_DIR}"
	doins -r * || die "failed to install ${JAR_FILE} to ${INSTALL_DIR}"

	insinto "${CONFIG_DIR}"
	doins "${FILESDIR}"/jmx_exporter.yaml
}

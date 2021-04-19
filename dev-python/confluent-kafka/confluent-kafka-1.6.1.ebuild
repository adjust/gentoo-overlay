# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

MY_PN="confluent-kafka-python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A reliable, performant and feature rich Python client for Apache Kafka"
HOMEPAGE="http://docs.confluent.io/current/clients/confluent-kafka-python"
SRC_URI="https://github.com/confluentinc/${MY_PN}/archive/v${PV}.tar.gz"

RESTRICT="test" # We're missing trivup

LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"

SLOT="0"

IUSE=""

# We're skipping avro/json until we packaged fastavro

RDEPEND="
	>=dev-libs/librdkafka-1.4.0
"

DEPEND="
	${RDEPEND}
"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all
	# setup.py defines LICENSE.txt as a data_file so we reap it here
	rm "${D}/usr/LICENSE.txt" || die 'failed to remove LICENSE.txt'
}

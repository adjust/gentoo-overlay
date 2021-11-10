# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )

inherit python-single-r1

MY_PN="aerospike-zabbix"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Zabbix plugin for Aerospike v4.x"
HOMEPAGE="https://github.com/aerospike-community/aerospike-zabbix"
SRC_URI="https://github.com/aerospike-community/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	${PYTHON_DEPS}
	net-analyzer/zabbix"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	default
	python_fix_shebang .
}

src_install() {
	dodoc Readme.md
	insinto usr/share/zabbix/externalscripts
	doins -r *.py ssl
	fperms 750 /usr/share/zabbix/externalscripts/aerospike_discovery.py
	fowners zabbix:zabbix /usr/share/zabbix/externalscripts/aerospike_discovery.py
}

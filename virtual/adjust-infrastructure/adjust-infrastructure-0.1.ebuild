# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for tools used in Adjust's infrastructure"

KEYWORDS="~amd64"

SLOT="0"

IUSE=""

RDEPEND="
	app-admin/trex
	dev-perl/autovivification
	dev-perl/Data-Printer
	dev-perl/Digest-CRC
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/JSON-MaybeXS
	dev-perl/libwww-perl
	dev-perl/NetAddr-IP
	dev-perl/Net-CIDR-Lite
	dev-perl/Number-Bytes-Human
	dev-perl/Path-Tiny
	dev-perl/Search-Elasticsearch
	dev-perl/Search-Elasticsearch-Client-2_0
	dev-perl/String-ShellQuote
	dev-perl/Term-ProgressBar
	dev-perl/Try-Tiny
	dev-perl/YAML
	dev-perl/Zabbix-Tiny
"

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/maxmind/${PN}"

EGO_VENDOR=(
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/gofrs/flock v0.7.1"
	"github.com/kr/pretty v0.1.0"
	"github.com/pkg/errors v0.8.1"
	"github.com/spf13/pflag v1.0.3"
	"github.com/stretchr/testify v1.3.0"
	"gopkg.in/check.v1 788fd78401277ebd861206a03c884797c6ec5541 github.com/go-check/check"
)

inherit golang-vcs-snapshot

DESCRIPTION="performs automatic updates of GeoIP2 and GeoIP Legacy binary databases"
HOMEPAGE="https://${EGO_PN}"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="amd64"

DOCS=( GeoIP.conf.md geoipupdate.md )

src_compile() {
	cd src/${EGO_PN} || die
	# requires pandoc but the information is still in the distributed md files
	sed -i -e '/GeoIP.conf.5 /d' -e '/geoipupdate.1$/d' Makefile || die
	default
}

src_install() {
	cd src/${EGO_PN}/build || die
	default
	keepdir /usr/share/GeoIP
	insinto /etc
	doins GeoIP.conf
}

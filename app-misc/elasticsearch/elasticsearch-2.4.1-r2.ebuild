# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd java-pkg-opt-2

MY_PN="${PN%-bin}"
DESCRIPTION="Open Source, Distributed, RESTful, Search Engine"
HOMEPAGE="https://www.elastic.co/products/elasticsearch"
SRC_URI="https://download.elasticsearch.org/${MY_PN}/release/org/${MY_PN}/distribution/tar/${MY_PN}/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="
	acct-group/elasticsearch
	acct-user/elasticsearch
	sys-process/numactl
	>=virtual/jre-1.8
"

DEPEND="
	>=virtual/jdk-1.8
"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

pkg_preinst() {
	if has_version '<app-misc/elasticsearch-2.3.2'; then
		export UPDATE_NOTES=1
	fi
}

src_prepare() {
	rm -r bin/*.{bat,exe} || die
	rm LICENSE.txt
}

src_install() {
	dodir /etc/${MY_PN}
	dodir /etc/${MY_PN}/scripts

	insinto /etc/${MY_PN}
	doins config/*
	rm -r config || die

	insinto /usr/share/${MY_PN}
	doins -r ./*

	insinto /usr/share/${MY_PN}/bin
	doins "${FILESDIR}/elasticsearch-systemd-pre-exec"

	chmod +x "${D}"/usr/share/${MY_PN}/bin/*

	keepdir /var/{lib,log}/${MY_PN}
	keepdir /usr/share/${MY_PN}/plugins

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${MY_PN}.sysctl.d" "${MY_PN}.conf"

	newinitd "${FILESDIR}/elasticsearch.init7" "${MY_PN}"
	newconfd "${FILESDIR}/${MY_PN}.conf2" "${MY_PN}"
	systemd_newunit "${FILESDIR}"/${PN}.service5 "${PN}.service"
}

pkg_postinst() {
	elog
	elog "You may create multiple instances of ${MY_PN} by"
	elog "symlinking the init script:"
	elog "ln -sf /etc/init.d/${MY_PN} /etc/init.d/${MY_PN}.instance"
	elog
	elog "Please make sure you put elasticsearch.yml and logging.yml"
	elog "into the configuration directory of the instance:"
	elog "/etc/${MY_PN}/instance"
	elog
	if ! [ -z ${UPDATE_NOTES} ]; then
		elog "This update changes some configuration variables. Please review"
		elog "/etc/conf.d/elasticsearch before restarting your services."
	fi
}

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit versionator

MAJ_PV="$(get_major_version)"
MED_PV="$(get_version_component_range 2)"
MIN_PV="$(get_version_component_range 3)"

DESCRIPTION="An open source, highly scalable, schema-free document-oriented database"
HOMEPAGE="http://www.basho.com/"
SRC_URI="http://downloads.basho.com/${PN}/${PN}-${MAJ_PV}.${MED_PV}.${MIN_PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="smp kpoll hipe"

RDEPEND="
         smp? ( >=dev-lang/erlang-14.2.2[smp] )
         kpoll? ( >=dev-lang/erlang-14.2.2[kpoll] )
         hipe? ( >=dev-lang/erlang-14.2.2[hipe] )
         !smp? ( >=dev-lang/erlang-14.2.2[-smp] )
         !kpoll? ( >=dev-lang/erlang-14.2.2[-kpoll] )
         !hipe? ( >=dev-lang/erlang-14.2.2[-hipe] )
         <dev-lang/erlang-14.2.5
         dev-vcs/git
        "
DEPEND="${RDEPEND}"

pkg_setup() {
    enewgroup riak
    enewuser riak -1 /bin/bash /var/lib/${PN} riak
}

src_prepare() {
    epatch "${FILESDIR}/1000-fix-directories.patch"
    sed -i -e 's/XLDFLAGS="$(LDFLAGS)"//g' -e 's/ $(CFLAGS)//g' deps/erlang_js/c_src/Makefile || die
}

src_compile() {
    emake rel
}

src_install() {
    # install /usr/lib stuff
    insinto /usr/lib/${PN}
    cp -R rel/riak/lib "${D}"/usr/lib/riak
    cp -R rel/riak/releases "${D}"/usr/lib/riak
    cp -R rel/riak/erts* "${D}"/usr/lib/riak
    chmod 0755 "${D}"/usr/lib/riak/erts*/bin/*

    # install /usr/bin stuff
    dobin rel/riak/bin/*

    # install /etc/riak stuff
    insinto /etc/${PN}
    doins rel/riak/etc/*

    # create neccessary directories
    keepdir /var/lib/${PN}/{bitcask,ring}
    keepdir /var/log/${PN}/sasl
    keepdir /var/run/${PN}

    # change owner to riak
    fowners riak.riak /var/lib/${PN}
    fowners riak.riak /var/lib/${PN}/ring
    fowners riak.riak /var/lib/${PN}/bitcask
    fowners riak.riak /var/log/${PN}
    fowners riak.riak /var/log/${PN}/sasl
    fowners riak.riak /var/run/${PN}

    # create docs
    doman doc/man/man1/*
    dodoc doc/*.txt

    # init.d file
    newinitd "${FILESDIR}/${PN}.initd" ${PN}
    newconfd "${FILESDIR}/${PN}.confd" ${PN}

}

pkg_postinst() {
    if [ -a /tmp/riak ]; then
        ewarn "The PIPE_DIR /tmp/riak exists."
        ewarn "Make sure you have the correct permissions set before starting riak"
    fi
    ewarn "If you updated from a version before 1.1.2 check permissions on:"
    ewarn "/var/lib/riak"
    ewarn "/var/lob/riak"
    ewarn "/tmp/riak"
    ewarn "The default user to run riak is 'riak'"
}


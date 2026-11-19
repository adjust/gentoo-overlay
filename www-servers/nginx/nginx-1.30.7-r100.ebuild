# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# ::gentoo www-servers/nginx-1.30.7 with yaoweibin/nginx_upstream_check_module
# compiled in statically.  The module patches NGINX core (round robin, hash,
# ip_hash and least_conn balancers) and the patched core calls into the module,
# so it cannot be packaged as a separate www-nginx/* dynamic module.

EAPI=8

NGINX_SUBSYSTEMS=(+http stream mail)
NGINX_MODULES=(
	+http_{charset,gzip,ssi,userid,access,auth_basic,mirror,autoindex,geo,map}
	+http_{split_clients,referer,rewrite,proxy,fastcgi,uwsgi,scgi,grpc}
	+http_{memcached,limit_conn,limit_req,empty_gif,browser,upstream_hash}
	+http_{upstream_ip_hash,upstream_least_conn,upstream_random}
	+http_{upstream_keepalive,upstream_zone}
	http_{ssl,v2,v3,realip,addition,xslt,image_filter,geoip,sub,dav,flv,mp4}
	http_{gunzip,gzip_static,auth_request,random_index,secure_link,degradation}
	http_{slice,stub_status,perl}
	+mail_{pop3,imap,smtp}
	mail_ssl
	+stream_{limit_conn,access,geo,map,split_clients,return,pass,set}
	+stream_{upstream_hash,upstream_least_conn,upstream_random,upstream_zone}
	stream_{ssl,realip,geoip,ssl_preread}
)
NGINX_TESTS_COMMIT=cf2b5bf5f98f578a0a3da13c8c507c996f5f74fe
NGINX_MISC_FILES=(
	nginx-{r2.logrotate,r2.service,r5.conf,r6.initd,r1.confd,r1.tmpfiles}
)
NGINX_SUPPORT_MODULE_STUBS=1

inherit nginx

UPSTREAM_CHECK_COMMIT="02c6c9de14ca1e60adb9f48179707c57d532d622"
UPSTREAM_CHECK_S="${WORKDIR}/nginx_upstream_check_module-${UPSTREAM_CHECK_COMMIT}"

SRC_URI+="
	https://github.com/yaoweibin/nginx_upstream_check_module/archive/${UPSTREAM_CHECK_COMMIT}.tar.gz
		-> nginx_upstream_check_module-${UPSTREAM_CHECK_COMMIT}.tar.gz
"
LICENSE+=" BSD"

KEYWORDS="amd64"

PATCHES=(
	"${FILESDIR}/${PN}-httpoxy-mitigation-r1.patch"
	"${UPSTREAM_CHECK_S}/check_1.30.4+.patch"
)

src_configure() {
	nginx_src_configure --add-module="${UPSTREAM_CHECK_S}"
}

src_install() {
	nginx_src_install

	if use modules; then
		# nginx-module.eclass replays the stored ./configure flags, including
		# --add-module, when building dynamic modules.  Install the module
		# source at a stable path and point the stored flag at it, so that
		# www-nginx/* modules are built with NGX_HTTP_UPSTREAM_CHECK defined
		# (the patched ngx_http_upstream_rr_peer_t carries an extra field).
		local dest="/usr/src/nginx/upstream_check"
		insinto "${dest}"
		doins "${UPSTREAM_CHECK_S}"/{config,ngx_http_upstream_check_module.{c,h}}
		sed -i "s|${UPSTREAM_CHECK_S}|${EPREFIX}${dest}|" \
			"${ED}/usr/src/nginx/configure-flags" || die "sed failed"
	fi
}

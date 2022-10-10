# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit llvm

# We handle GIT dependencies specially since cargo runs in offline mode.
PROMETHEUS_PARSE_COMMIT="a4574e9bade29b8af31e68b68a5392c61cbb74cd"
RUST_PCRE2_COMMIT="8096355b43e26db1eb73010e3be404aedc10f81d"
LOGDNA_CLIENT_COMMIT="1803b6fda29e2e1f3de47b30b07a55359bb8efd7"
ASYNC_BUF_POOL_COMMIT="667927ba770a08a153097a833eca73c619593f20"

CRATES="
	adler-1.0.2
	ahash-0.7.6
	aho-corasick-0.7.19
	android_system_properties-0.1.5
	ansi_term-0.12.1
	anyhow-1.0.64
	assert_cmd-2.0.4
	async-channel-1.7.1
	async-compat-0.2.1
	async-compression-0.3.14
	async-stream-0.3.3
	async-stream-impl-0.3.3
	async-trait-0.1.57
	atty-0.2.14
	auditable-0.1.0
	auditable-build-0.1.0
	auditable-serde-0.1.0
	autocfg-1.1.0
	backoff-0.4.0
	base64-0.13.0
	binary-merge-0.1.2
	bindgen-0.60.1
	bit-set-0.5.3
	bit-vec-0.6.3
	bitflags-1.3.2
	bstr-0.2.17
	build-env-0.3.1
	bumpalo-3.11.0
	byteorder-1.4.3
	bytes-1.2.1
	bzip2-sys-0.1.11+1.0.8
	cache-padded-1.2.0
	capctl-0.2.2
	cargo_metadata-0.11.4
	cc-1.0.73
	cexpr-0.6.0
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.22
	clang-sys-1.3.3
	clap-2.34.0
	combine-4.6.6
	concurrent-queue-1.2.4
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	countme-2.0.4
	crc32fast-1.3.2
	crossbeam-0.8.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.10
	crossbeam-queue-0.3.6
	crossbeam-utils-0.8.11
	cstr-argument-0.1.2
	derivative-2.2.0
	difflib-0.4.0
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	either-1.8.0
	encoding-0.2.33
	encoding-index-japanese-1.20141219.5
	encoding-index-korean-1.20141219.5
	encoding-index-simpchinese-1.20141219.5
	encoding-index-singlebyte-1.20141219.5
	encoding-index-tradchinese-1.20141219.5
	encoding_index_tests-0.1.4
	env_logger-0.9.0
	escargot-0.5.7
	event-listener-2.5.3
	fastrand-1.8.0
	filetime-0.2.17
	flate2-1.0.24
	flexi_logger-0.22.6
	float-cmp-0.9.0
	fnv-1.0.7
	foreign-types-0.5.0
	foreign-types-macros-0.2.2
	foreign-types-shared-0.3.1
	form_urlencoded-1.0.1
	fs_extra-1.2.0
	fsevent-0.4.0
	fsevent-sys-2.0.1
	fuchsia-zircon-0.3.3
	fuchsia-zircon-sys-0.3.3
	futures-0.3.24
	futures-channel-0.3.24
	futures-core-0.3.24
	futures-executor-0.3.24
	futures-io-0.3.24
	futures-macro-0.3.24
	futures-sink-0.3.24
	futures-task-0.3.24
	futures-timer-3.0.2
	futures-util-0.3.24
	getrandom-0.2.7
	glob-0.3.0
	h2-0.3.14
	hashbrown-0.12.3
	heck-0.3.3
	heck-0.4.0
	hermit-abi-0.1.19
	hex-0.4.3
	http-0.2.8
	http-body-0.4.5
	http-range-header-0.3.0
	httparse-1.8.0
	httpdate-1.0.2
	humanize-rs-0.1.5
	humantime-2.1.0
	hyper-0.14.20
	hyper-rustls-0.23.0
	hyper-timeout-0.4.1
	iana-time-zone-0.1.47
	idna-0.2.3
	indexmap-1.9.1
	inotify-0.7.1
	inotify-sys-0.1.5
	inplace-vec-builder-0.1.1
	instant-0.1.12
	iovec-0.1.4
	ipnetwork-0.18.0
	ipnetwork-0.19.0
	itertools-0.10.3
	itoa-1.0.3
	java-properties-1.4.1
	jobserver-0.1.24
	js-sys-0.3.59
	json-0.12.4
	json-patch-0.2.6
	jsonpath_lib-0.3.0
	k8s-openapi-0.15.0
	kernel32-sys-0.2.2
	kube-0.73.1
	kube-client-0.73.1
	kube-core-0.73.1
	kube-runtime-0.73.1
	lazy_static-1.4.0
	lazycell-1.3.0
	libc-0.2.132
	libloading-0.7.3
	librocksdb-sys-0.8.0+7.4.4
	libsystemd-sys-0.9.3
	libz-sys-1.1.8
	linked-hash-map-0.5.6
	lock_api-0.4.8
	log-0.4.17
	matches-0.1.9
	memchr-2.5.0
	memoffset-0.6.5
	minimal-lexical-0.2.1
	miniz_oxide-0.4.4
	miniz_oxide-0.5.4
	mio-0.6.23
	mio-0.8.4
	mio-extras-2.0.6
	miow-0.2.2
	net2-0.2.37
	nix-0.24.2
	no-std-net-0.6.0
	nom-7.1.1
	normalize-line-endings-0.3.0
	notify-4.0.17
	ntapi-0.3.7
	num-0.4.0
	num-bigint-0.4.3
	num-complex-0.4.2
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.13.1
	num_threads-0.1.6
	once_cell-1.14.0
	openssl-probe-0.1.5
	ordered-float-2.10.0
	os_str_bytes-6.3.0
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	partial-io-0.5.0
	paste-1.0.9
	peeking_take_while-0.1.2
	pem-1.1.0
	percent-encoding-2.1.0
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	pnet-0.28.0
	pnet_base-0.28.0
	pnet_base-0.31.0
	pnet_datalink-0.28.0
	pnet_datalink-0.31.0
	pnet_macros-0.28.0
	pnet_macros_support-0.28.0
	pnet_packet-0.28.0
	pnet_sys-0.28.0
	pnet_sys-0.31.0
	pnet_transport-0.28.0
	ppv-lite86-0.2.16
	predicates-2.1.1
	predicates-core-1.0.3
	predicates-tree-1.0.5
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	procfs-0.12.0
	prometheus-0.13.1
	proptest-1.0.0
	protobuf-2.27.1
	quick-error-1.2.3
	quick-error-2.0.1
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_xorshift-0.3.0
	rayon-1.5.3
	rayon-core-1.9.3
	rcgen-0.9.3
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-automata-0.1.10
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	ring-0.16.20
	rocksdb-0.19.0
	rustc-hash-1.1.0
	rustls-0.20.6
	rustls-native-certs-0.6.2
	rustls-pemfile-1.0.1
	rustversion-1.0.9
	rusty-fork-0.3.0
	ryu-1.0.11
	same-file-1.0.6
	schannel-0.1.20
	scopeguard-1.1.0
	sct-0.7.0
	secrecy-0.8.0
	security-framework-2.7.0
	security-framework-sys-2.6.1
	semver-0.10.0
	semver-parser-0.7.0
	serde-1.0.144
	serde-value-0.7.0
	serde_derive-1.0.144
	serde_json-1.0.85
	serde_urlencoded-0.7.1
	serde_yaml-0.8.26
	serial_test-0.8.0
	serial_test_derive-0.8.0
	shlex-1.1.0
	signal-hook-registry-1.4.0
	slab-0.4.7
	slotmap-1.0.6
	smallvec-1.9.0
	socket2-0.4.7
	sorted-iter-0.1.8
	spin-0.5.2
	strsim-0.8.0
	structopt-0.3.26
	structopt-derive-0.4.18
	strum-0.24.1
	strum_macros-0.24.3
	syn-1.0.99
	sysinfo-0.24.7
	systemd-0.10.0
	tempfile-3.3.0
	termcolor-1.1.3
	termtree-0.2.4
	textwrap-0.11.0
	thiserror-1.0.34
	thiserror-impl-1.0.34
	thread_local-1.1.4
	tikv-jemalloc-ctl-0.5.0
	tikv-jemalloc-sys-0.5.1+5.3.0-patched
	tikv-jemallocator-0.5.0
	time-0.1.44
	time-0.3.9
	time-macros-0.2.4
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.21.0
	tokio-io-timeout-1.2.0
	tokio-macros-1.8.0
	tokio-rustls-0.23.4
	tokio-stream-0.1.9
	tokio-test-0.4.2
	tokio-util-0.7.3
	tower-0.4.13
	tower-http-0.3.4
	tower-layer-0.3.1
	tower-service-0.3.2
	tracing-0.1.36
	tracing-attributes-0.1.22
	tracing-core-0.1.29
	treediff-3.0.2
	try-lock-0.2.3
	unicode-bidi-0.3.8
	unicode-ident-1.0.3
	unicode-normalization-0.1.21
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	untrusted-0.7.1
	url-2.2.2
	utf-8-0.7.6
	utf8-cstr-0.1.6
	uuid-1.1.2
	vcpkg-0.2.15
	vec-collections-0.4.3
	vec_map-0.8.2
	version_check-0.9.4
	wait-timeout-0.2.0
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	web-sys-0.3.59
	webpki-0.22.0
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	ws2_32-sys-0.2.1
	yaml-rust-0.4.5
	yasna-0.5.0
	zeroize-1.5.7
	zstd-sys-2.0.1+zstd.1.5.2
"

inherit cargo

DESCRIPTION="LogDNA's collector agent which streams log files to your LogDNA account"
HOMEPAGE="https://github.com/logdna/logdna-agent-v2"
SRC_URI="
	https://github.com/logdna/${PN}-v2/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
	https://github.com/ccakes/prometheus-parse-rs/archive/${PROMETHEUS_PARSE_COMMIT}.tar.gz -> prometheus-parse-${PROMETHEUS_PARSE_COMMIT}.tar.gz
	https://github.com/logdna/rust-pcre2/archive/${RUST_PCRE2_COMMIT}.tar.gz -> rust-pcre2-${RUST_PCRE2_COMMIT}.tar.gz
	https://github.com/logdna/logdna-rust/archive/${LOGDNA_CLIENT_COMMIT}.tar.gz -> logdna-client-${LOGDNA_CLIENT_COMMIT}.tar.gz
	https://github.com/logdna/async-buf-pool-rs/archive/${ASYNC_BUF_POOL_COMMIT}.tar.gz -> async-buf-pool-${ASYNC_BUF_POOL_COMMIT}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-v2-${PV}"

BDEPEND="
	sys-devel/clang:=
	>=virtual/rust-1.57.0
"

RDEPEND="
	dev-libs/libpcre2:=
"

src_prepare() {
	default

	# Strip off unneeded dependencies, turn git deps into path deps for offline mode.
	sed -i \
		-e '/winservice/d' \
		-e "/^prometheus-parse/s:git.*:path = \"${WORKDIR}/prometheus-parse-rs-${PROMETHEUS_PARSE_COMMIT}\" }:" \
		"${S}"/bin/Cargo.toml "${S}"/utils/metrics-recorder/Cargo.toml \
		|| die "sed failed"

	sed -i \
		-e "/^pcre2/s:git.*:path = \"${WORKDIR}/rust-pcre2-${RUST_PCRE2_COMMIT}\" }:" \
		"${S}"/common/fs/Cargo.toml || die "sed failed"

	sed -i \
		-e "/^logdna-client/s:git.*:path = \"${WORKDIR}/logdna-rust-${LOGDNA_CLIENT_COMMIT}\" }:" \
		"${S}"/common/http/Cargo.toml "${S}"/common/test/types/Cargo.toml \
		|| die "sed failed"

	sed -i \
		-e "/^async-buf-pool/s:git.*:path = \"${WORKDIR}/async-buf-pool-rs-${ASYNC_BUF_POOL_COMMIT}\" }:" \
		"${WORKDIR}/logdna-rust-${LOGDNA_CLIENT_COMMIT}/Cargo.toml" \
		|| die "sed failed"
}

src_compile() {
	# Help cargo build locate libclang.so
	export LIBCLANG_PATH="$(get_llvm_prefix)/$(get_libdir)"

	cargo_src_compile
}

src_install() {
	dobin target/release/${PN}
	dodoc docs/*

	newconfd "${FILESDIR}"/logdna.conf logdna-agent
	newinitd "${FILESDIR}"/logdna.init logdna-agent
}

# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs mount-boot toolchain-funcs

DESCRIPTION="Linux kernel sources with some additional patches."
HOMEPAGE="https://kernel.org"

LICENSE="GPL-2"
KEYWORDS="amd64"

SLOT="${PV}"

RESTRICT="binchecks mirror strip"

# general kernel USE flags
IUSE="build-kernel clang compress debug +dracut symlink"
# optimize
IUSE="${IUSE} custom-cflags"
# security
IUSE="${IUSE} hardened +kpti +retpoline selinux sign-modules"
# initramfs
IUSE="${IUSE} btrfs firmware luks lvm mdadm microcode plymouth systemd udev zfs"
# misc kconfig tweaks
IUSE="${IUSE} +mcelog +memcg +numa"

BDEPEND="
	sys-devel/bc
	debug? ( dev-util/pahole )
	sys-devel/flex
	virtual/libelf
	virtual/yacc
"

RDEPEND="
	build-kernel? (
		dracut? ( sys-kernel/dracut )
		!dracut? ( sys-kernel/genkernel )
	)
	btrfs? ( sys-fs/btrfs-progs )
	compress? ( sys-apps/kmod[lzma] )
	firmware? (
		sys-kernel/linux-firmware
	)
	luks? ( sys-fs/cryptsetup )
	lvm? ( sys-fs/lvm2 )
	mdadm? ( sys-fs/mdadm )
	mcelog? ( app-admin/mcelog )
	plymouth? (
		x11-libs/libdrm[libkms]
		sys-boot/plymouth[libkms,udev]
	)
	sign-modules? (
		dev-libs/openssl
		sys-apps/kmod
	)
	zfs? ( sys-fs/zfs )
"

REQUIRED_USE="
	sign-modules? ( build-kernel )
"


KERNEL_VERSION="${PV%%_*}"
KERNEL_EXTRAVERSION="-debian"
KERNEL_FULL_VERSION="${KERNEL_VERSION}${KERNEL_EXTRAVERSION}"

DEBIAN_UPSTREAM="https://ftp.debian.org/debian/pool/main/l/linux"
KERNEL_ARCHIVE="linux_${KERNEL_VERSION}.orig.tar.xz"
PATCH_ARCHIVE="linux_${PV/_p/-}.debian.tar.xz"

SRC_URI="
	${DEBIAN_UPSTREAM}/${KERNEL_ARCHIVE}
	${DEBIAN_UPSTREAM}/${PATCH_ARCHIVE}
"

S="$WORKDIR/linux-${KERNEL_VERSION}"

tweak_config() {
	echo "$1" >> .config || die "failed to tweak \"$1\" in the kernel config"
}

get_patch_list() {
	[[ -z "${1}" ]] && die "No patch series file specified"
	local patch_series="${1}"
	while read line ; do
		if [[ "${line:0:1}" != "#" ]] ; then
			echo "${line}"
		fi
	done < "${patch_series}"
}

get_certs_dir() {
	# find a certificate dir in /etc/kernel/certs/ that contains signing cert for modules.
	for subdir in ${PF} ${P} linux; do
		certdir=/etc/kernel/certs/${subdir}
		if [[ -d ${certdir} ]]; then
			if [[ ! -e ${certdir}/signing_key.pem ]]; then
				die  "${certdir} exists but missing signing key; exiting."
				exit 1
			fi
			echo ${certdir}
			return
		fi
	done
}

pkg_pretend() {

	# perform sanity checks that only apply to source builds.
	if [[ ${MERGE_TYPE} != binary ]] && use build-kernel; then

		# Ensure we have enough disk space to compile
		CHECKREQS_DISK_BUILD="5G"
		check-reqs_pkg_setup
	fi

	# perform sanity checks that apply to both source + binary packages.
	if use build-kernel; then
		# check that our boot partition (if it exists) is mounted
		mount-boot_pkg_pretend

		# check that we have enough free space in the boot partition
		CHECKREQS_DISK_BOOT="64M"
		check-reqs_pkg_setup

		# a lot of hardware requires firmware
		if ! use firmware; then
			ewarn "sys-kernel/linux-firmware not found installed on your system."
			ewarn "This package provides firmware that may be needed for your hardware to work."
		fi
	fi
}

pkg_setup() {

	export REAL_ARCH="${ARCH}"

	# will interfere with Makefile if set
	unset ARCH
	unset LDFLAGS
}

src_unpack() {

	# unpack the kernel sources to ${WORKDIR}
	unpack ${KERNEL_ARCHIVE}

	# unpack the kernel patches to ${WORKDIR}
	unpack ${PATCH_ARCHIVE}
}

src_prepare() {

	# punt Debian dev certs
	rm -rf ${S}/debian/certs || die "failed to remove Debian certs"

# PATCH:

	# todo
	einfo "Applying Debian patches ..."
	for deb_patch in $( get_patch_list "${WORKDIR}/debian/patches/series" ); do
		eapply "${WORKDIR}"/debian/patches/${deb_patch}
	done

	# apply any user patches
	eapply_user

	# append EXTRAVERSION to the kernel sources Makefile
	sed -i -e "s:^\(EXTRAVERSION =\).*:\1 ${KERNEL_EXTRAVERSION}:" Makefile || die "failed to append EXTRAVERSION to kernel Makefile"

	# todo: look at this, haven't seen it used in many cases.
	sed -i -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' Makefile || die "failed to fix-up INSTALL_PATH in kernel Makefile"

	# copy the debian patches into the kernel sources work directory (config-extract requires this).
	cp -a "${WORKDIR}"/debian "${S}"/debian || die "failed to copy Debian archive to kernel source tree"

	local arch featureset subarch
	featureset="standard"
	if [[ ${REAL_ARCH} == x86 ]]; then
		arch="i386"
		subarch="686-pae"
	elif [[ ${REAL_ARCH} == amd64 ]]; then
		arch="amd64"
		subarch="amd64"
	elif [[ ${REAL_ARCH} == arm64 ]]; then
		arch="arm64"
		subarch="arm64"
	else
	    die "Architecture not handled in ebuild"
	fi

	# Copy 'config-extract' tool to the work directory
	cp "${FILESDIR}"/config-extract . || die "failed to install config-extract to sources directory"

	# ... and make it executable
	chmod +x config-extract || die "failed to set +x on config-extract"

	# ... and now extract the kernel config file!
	./config-extract ${arch} ${featureset} ${subarch} || die "failed to generate kernel config"

# CONFIG:

	# Do not configure Debian trusted certificates
	tweak_config 'CONFIG_SYSTEM_TRUSTED_KEYS=""'

	# enable IKCONFIG so that /proc/config.gz can be used for various checks
	# TODO: Maybe not a good idea for USE=hardened, look into this...
	tweak_config "CONFIG_IKCONFIG=y"
	tweak_config "CONFIG_IKCONFIG_PROC=y"

	# enable kernel module compression ...
	# ... defaulting to xz compression
	if use compress; then
		tweak_config "CONFIG_MODULE_COMPRESS_NONE=n"
		tweak_config "CONFIG_MODULE_COMPRESS_GZIP=n"
		tweak_config "CONFIG_MODULE_COMPRESS_ZSTD=n"
		tweak_config "CONFIG_MODULE_COMPRESS_XZ=y"
	else
		tweak_config "CONFIG_MODULE_COMPRESS_NONE=y"
	fi

	# only enable debugging symbols etc if USE=debug...
	if use debug; then
		tweak_config "CONFIG_DEBUG_INFO=y"
	else
		tweak_config "CONFIG_DEBUG_INFO=n"
	fi

	if use hardened; then

		# TODO: HARDENING

		# disable gcc plugins on clang
		if use clang; then
			tweak_config "CONFIG_GCC_PLUGINS=n"
		fi

		# main hardening options complete... anything after this point is a focus on disabling potential attack vectors
		# i.e legacy drivers, new complex code that isn't yet proven, or code that we really don't want in a hardened kernel.

		# Kexec is a syscall that enables loading/booting into a new kernel from the currently running kernel.
		# This has been used in numerous exploits of various systems over the years, so we disable it.
		tweak_config 'CONFIG_KEXEC=n'
		tweak_config "CONFIG_KEXEC_FILE=n"
		tweak_config 'CONFIG_KEXEC_SIG=n'
	fi

	# mcelog is deprecated, but there are still some valid use cases and requirements for it... so stick it behind a USE flag for optional kernel support.
	if use mcelog; then
		tweak_config "CONFIG_X86_MCELOG_LEGACY=y"
	fi

	if use memcg; then
		tweak_config "CONFIG_MEMCG=y"
	else
		tweak_config "CONFIG_MEMCG=n"
	fi

	if use numa; then
		tweak_config "CONFIG_NUMA_BALANCING=y"
	else
		tweak_config "CONFIG_NUMA_BALANCING=n"
	fi

	if use kpti; then
		tweak_config "CONFIG_PAGE_TABLE_ISOLATION=y"
		if use arm64; then
			tweak_config "CONFIG_UNMAP_KERNEL_AT_EL0=y"
		fi
	else
		tweak_config "CONFIG_PAGE_TABLE_ISOLATION=n"
		if use arm64; then
			tweak_config "CONFIG_UNMAP_KERNEL_AT_EL0=n"
		fi
	fi

	if use retpoline; then
		if use amd64 || use arm64 || use ppc64 || use x86; then
			tweak_config "CONFIG_RETPOLINE=y"
		elif use arm; then
			tweak_config "CONFIG_CPU_SPECTRE=y"
			tweak_config "CONFIG_HARDEN_BRANCH_PREDICTOR=y"
		fi
	else
		if use amd64 || use arm64 || use ppc64 || use x86; then
			tweak_config "CONFIG_RETPOLINE=n"
		elif use arm; then
			tweak_config "CONFIG_CPU_SPECTRE=n"
			tweak_config "CONFIG_HARDEN_BRANCH_PREDICTOR=n"
		fi

	fi

	# sign kernel modules via
	if use sign-modules; then
		certs_dir=$(get_certs_dir)
		if [[ -z "${certs_dir}" ]]; then
			die "No certs dir found in /etc/kernel/certs; aborting."
		else
			einfo "Using certificate directory of ${certs_dir} for kernel module signing."
		fi
		# turn on options for signing modules.
		# first, remove existing configs and comments:
		tweak_config 'CONFIG_MODULE_SIG=""'

		# now add our settings:
		tweak_config 'CONFIG_MODULE_SIG=y'
		tweak_config 'CONFIG_MODULE_SIG_FORCE=n'
		tweak_config 'CONFIG_MODULE_SIG_ALL=n'
		tweak_config 'CONFIG_MODULE_SIG_HASH="sha512"'
		tweak_config 'CONFIG_MODULE_SIG_KEY="${certs_dir}/signing_key.pem"'
		tweak_config 'CONFIG_SYSTEM_TRUSTED_KEYRING=y'
		tweak_config 'CONFIG_SYSTEM_EXTRA_CERTIFICATE=y'
		tweak_config 'CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE="4096"'
		tweak_config "CONFIG_MODULE_SIG_SHA512=y"
	fi

	# get config into good state:
	yes "" | make oldconfig >/dev/null 2>&1 || die
	cp .config "${T}"/.config || die
	make -s mrproper || die "make mrproper failed"
}

src_configure() {

	if use build-kernel; then
		tc-export_build_env
		MAKEARGS=(
			V=1

			HOSTCC="$(tc-getBUILD_CC)"
			HOSTCXX="$(tc-getBUILD_CXX)"
			HOSTCFLAGS="${BUILD_CFLAGS}"
			HOSTLDFLAGS="${BUILD_LDFLAGS}"

			CROSS_COMPILE=${CHOST}-
			AS="$(tc-getAS)"
			CC="$(tc-getCC)"
			LD="$(tc-getLD)"
			AR="$(tc-getAR)"
			NM="$(tc-getNM)"
			STRIP=":"
			OBJCOPY="$(tc-getOBJCOPY)"
			OBJDUMP="$(tc-getOBJDUMP)"

			# we need to pass it to override colliding Gentoo envvar
			ARCH=$(tc-arch-kernel)
		)

		mkdir -p "${WORKDIR}"/build || die "failed to create build dir"
		cp "${T}"/.config "${WORKDIR}"/build/.config || die "failed to copy .config into build dir"

		local targets=( olddefconfig prepare modules_prepare scripts )

		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" "${targets[@]}" || die "kernel configure failed"

		cp -a "${WORKDIR}"/build "${WORKDIR}"/mod_prep
	fi
}

src_compile() {

	if use build-kernel; then
		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" all || "kernel build failed"
	fi
}

# this can likely be done a bit better
# TODO: create backups of kernel + initramfs if same ver exists?
install_kernel_and_friends() {

	install -d "${D}"/boot
	local kern_arch=$(tc-arch-kernel)

	cp "${WORKDIR}"/build/arch/${kern_arch}/boot/bzImage "${D}"/boot/vmlinuz-${KERNEL_FULL_VERSION} || die "failed to install kernel to /boot"
	cp "${T}"/.config "${D}"/boot/config-${KERNEL_FULL_VERSION} || die "failed to install kernel config to /boot"
	cp "${WORKDIR}"/build/System.map "${D}"/boot/System.map-${KERNEL_FULL_VERSION} || die "failed to install System.map to /boot"
}

src_install() {

	# 'standard' install of kernel sources that most consumers are used to ...
	# i.e. install sources to /usr/src/linux-${KERNEL_FULL_VERSION} and manually compile the kernel.
	if ! use build-kernel; then

		# create kernel sources directory
		dodir /usr/src

		# copy kernel sources into place
		cp -a "${S}" "${D}"/usr/src/linux-${KERNEL_FULL_VERSION} || die "failed to install kernel sources"

		# clean-up kernel source tree
		make mrproper || die "failed to prepare kernel sources"

		# copy kconfig into place
		cp "${T}"/.config "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/.config || die "failed to install kernel config"

	# let Portage handle the compilation, testing and installing of the kernel + initramfs,
	# and optionally installing kernel headers + signing the kernel modules.
	elif use build-kernel; then

		# ... maybe incoporate some [[ ${MERGE_TYPE} != foobar ]] so that headers can
		# be installed on a build server for emerging out-of-tree modules but the end consumer
		# e.g. container doesn't get the headers ...

		# standard target for installing modules to /lib/modules/${KERNEL_FULL_VERSION}
		local targets=( modules_install )

		# ARM / ARM64 requires dtb
		if (use arm || use arm64); then
			targets+=( dtbs_install )
		fi

		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" INSTALL_MOD_PATH="${D}" INSTALL_PATH="${D}"/boot "${targets[@]}"
		install_kernel_and_friends

		local kern_arch=$(tc-arch-kernel)
		dodir /usr/src/linux-${KERNEL_FULL_VERSION}
		mv include scripts "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/ || die

		dodir /usr/src/linux-${KERNEL_FULL_VERSION}/arch/${kern_arch}
		mv arch/${kern_arch}/include "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/arch/${kern_arch}/ || die

		# some arches need module.lds linker script to build external modules
		if [[ -f arch/${kern_arch}/kernel/module.lds ]]; then
			mv arch/${kern_arch}/kernel/module.lds "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/arch/${kern_arch}/kernel/
		fi

		# remove everything but Makefile* and Kconfig*
		find -type f '!' '(' -name 'Makefile*' -o -name 'Kconfig*' ')' -delete || die
		find -type l -delete || die
		cp -p -R * "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/ || die

		# todo mod_prep
		find "${WORKDIR}"/mod_prep -type f '(' -name Makefile -o -name '*.[ao]' -o '(' -name '.*' -a -not -name '.config' ')' ')' -delete || die
		rm -rf "${WORKDIR}"/mod_prep/source
		cp -p -R "${WORKDIR}"/mod_prep/* "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}

		# copy kconfig into place
		cp "${T}"/.config "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/.config || die "failed to install kconfig"

		# module symlink fix-up:
		rm -rf "${D}"/lib/modules/${KERNEL_FULL_VERSION}/source || die "failed to remove old kernel source symlink"
		rm -rf "${D}"/lib/modules/${KERNEL_FULL_VERSION}/build || die "failed to remove old kernel build symlink"

		# Set-up module symlinks:
		ln -s /usr/src/linux-${KERNEL_FULL_VERSION} "${D}"/lib/modules/${KERNEL_FULL_VERSION}/source || die "failed to create kernel source symlink"
		ln -s /usr/src/linux-${KERNEL_FULL_VERSION} "${D}"/lib/modules/${KERNEL_FULL_VERSION}/build || die "failed to create kernel build symlink"

		# Install System.map, Module.symvers and bzImage - required for building out-of-tree kernel modules:
		cp "${WORKDIR}"/build/System.map "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/ || die "failed to install System.map"
		cp "${WORKDIR}"/build/Module.symvers "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/ || die "failed to install Module.symvers"
		cp "${WORKDIR}"/build/arch/x86/boot/bzImage "${D}"/usr/src/linux-${KERNEL_FULL_VERSION}/arch/x86/boot/bzImage || die "failed to install bzImage"

		# USE=sign-modules depends on the scripts directory being available
		if use sign-modules; then
			for kmod in $(find "${D}"/lib/modules -iname *.ko); do
				# $certs_dir defined previously in this function.
				"${WORKDIR}"/build/scripts/sign-file sha512 ${certs_dir}/signing_key.pem ${certs_dir}/signing_key.x509 ${kmod} || die "failed to sign kernel modules"
			done
			# install the sign-file executable for future use.
			exeinto /usr/src/linux-${KERNEL_FULL_VERSION}/scripts
			doexe "${WORKDIR}"/build/scripts/sign-file
		fi
	fi
}

pkg_postinst() {

	# if USE=symlink...
	if use symlink; then
		# delete the existing symlink if one exists
		if [[ -h "${ROOT}"/usr/src/linux ]]; then
			rm "${ROOT}"/usr/src/linux || die "failed to delete existing /usr/src/linux symlink"
		fi
		# and now symlink the newly installed sources
		ewarn ""
		ewarn "WARNING... WARNING... WARNING"
		ewarn ""
		ewarn "/usr/src/linux symlink automatically set to linux-${KERNEL_FULL_VERSION}"
		ewarn ""
		ln -sf "${ROOT}"/usr/src/linux-${KERNEL_FULL_VERSION} "${ROOT}"/usr/src/linux || die "failed to create /usr/src/linux symlink"
	fi

	# rebuild the initramfs on post_install
	if use build-kernel; then

		if use dracut; then

			ewarn ">>> Dracut: building initramfs"

			dracut_modules_add="base"
			dracut_modules_omit="bootchart convertfs qemu"

			# call dracut and pass it arguments for the initramfs build
			dracut \
				--no-hostonly \
				--force \
				--kmoddir="${ROOT}/lib/modules/${KERNEL_FULL_VERSION}" \
				--add="${dracut_modules_add[@]}" \
				--omit="${dracut_modules_omit[@]}" \
				$(usex btrfs "--add=btrfs" "--omit=btrfs" ) \
				$(usex compress "--compress=xz" "--no-compress" ) \
				$(usex debug "--stdlog=5" "--stdlog=1" ) \
				$(usex firmware "--fwdir=/lib/firmware" "" ) \
				$(usex luks "--add=crypt" "--omit=crypt" ) \
				$(usex lvm "--add=lvm --lvmconf" "--omit=lvm --nolvmconf" ) \
				$(usex mdadm "--add=mdraid --mdadmconf" "--omit=mdraid --nomdadmconf" ) \
				$(usex microcode "--early-microcode" "--no-early-microcode" ) \
				$(usex plymouth "--add=plymouth" "--omit=plymouth" ) \
				$(usex selinux "--add=selinux" "--omit=selinux" ) \
				$(usex systemd "--add=systemd" "--omit=systemd" ) \
				$(usex udev "--add=udev-rules" "--omit=udev-rules" ) \
				$(usex zfs "--add=zfs" "--omit=zfs" ) \
				"${ROOT}"/boot/initramfs-${KERNEL_FULL_VERSION}.img ${KERNEL_FULL_VERSION} || die ">>> Dracut: building initramfs failed"

			ewarn ">>> Dracut: Finished building initramfs"

		elif ! use dracut; then

			# setup dirs for genkernel
			mkdir -p "${WORKDIR}"/genkernel/{tmp,cache,log} || die "failed to create setup directories for genkernel"

			genkernel \
				--color \
				--makeopts="${MAKEOPTS}" \
				--logfile="${WORKDIR}/genkernel/log/genkernel.log" \
				--cachedir="${WORKDIR}/genkernel/cache" \
				--tmpdir="${WORKDIR}/genkernel/tmp" \
				--kernel-config="/boot/config-${KERNEL_FULL_VERSION}" \
				--kerneldir="/usr/src/linux-${KERNEL_FULL_VERSION}" \
				--kernel-outputdir="/usr/src/linux-${KERNEL_FULL_VERSION}" \
				--all-ramdisk-modules \
				--busybox \
				$(usex btrfs "--btrfs" "--no-btrfs") \
				$(usex debug "--loglevel=5" "--loglevel=1") \
				$(usex firmware "--firmware" "--no-firmware") \
				$(usex luks "--luks" "--no-luks") \
				$(usex lvm "--lvm" "--no-lvm") \
				$(usex mdadm "--mdadm" "--no-mdadm") \
				$(usex mdadm "--mdadm-config=/etc/mdadm.conf" "") \
				$(usex microcode "--microcode-initramfs" "--no-microcode-initramfs") \
				$(usex udev "--udev-rules" "--no-udev-rules") \
				$(usex zfs "--zfs" "--no-zfs") \
				initramfs || die "failed to build initramfs"
		fi
	fi

	# warn about the issues with running a hardened kernel
	if use hardened; then
		ewarn ""
		ewarn "Hardened patches have been applied to the kernel and kconfig options have been set."
		ewarn "These kconfig options and patches change kernel behavior."
		ewarn ""
		ewarn "Changes include:"
		ewarn "    Increased entropy for Address Space Layout Randomization"
		if ! use clang; then
			ewarn "    GCC plugins"
		fi
		ewarn "    Memory allocation"
		ewarn "    ... and more"
		ewarn ""
		ewarn "These changes will stop certain programs from functioning"
		ewarn "e.g. VirtualBox, Skype"
		ewarn "Full information available in $DOCUMENTATION"
		ewarn ""
	fi

	if use sign-modules; then
		ewarn "This kernel will ALLOW non-signed modules to be loaded with a WARNING."
		ewarn "To enable strict enforcement, YOU MUST add module.sig_enforce=1 as a kernel boot parameter"
	fi
}

pkg_postrm() {

	# these clean-ups only apply if USE=build-kernel
	if use build-kernel; then

		# clean-up the generated initramfs for this kernel ...
		if [[ -f "${ROOT}"/boot/initramfs-${KERNEL_FULL_VERSION}.img ]]; then
			rm -f "${ROOT}"/boot/initramfs-${KERNEL_FULL_VERSION}.img || die "failed to remove initramfs-${KERNEL_FULL_VERSION}.img"
		fi

		# clean-up leftover kernel modules for this kernel ...
		if [[ -d "${ROOT}"/lib/modules/${KERNEL_FULL_VERSION} ]]; then
			rm -rf "${ROOT}"/lib/modules/${KERNEL_FULL_VERSION} || die "failed to remove /lib/modules/${KERNEL_FULL_VERSION}"
		fi
	fi
}

# adjust Gentoo overlay

Welcome to the adjust Gentoo overlay, a collection of tailored and bespoke
ebuilds for the adjust infrastructure.

## Build status

[![Build Status](https://travis-ci.org/adjust/gentoo-overlay.svg?branch=master)](https://travis-ci.org/adjust/gentoo-overlay)

## Setup

To get started using the adjust Gentoo overlay, first emerge the
eselect [repository](https://github.com/mgorny/eselect-repository) module:
```console
# emerge -av eselect-repository
```

Run the following commands as `root` then:
```console
# git clone https://github.com/adjust/gentoo-overlay /var/db/repos/adjust
# eselect repository add adjust git https://github.com/adjust/gentoo-overlay.git
```

The overlay should now appear in `eselect repository`'s list of managed overlays:
```console
 # eselect repository list -i
Available repositories:
  [22]  adjust @
  [157] gentoo # (https://gentoo.org/)
```

That's it!

Please make sure to read the `eselect repository usage` command output which
also serves as a helper/manual.

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit distutils-r1

HOMEPAGE='https://github.com/GoogleCloudPlatform/google-cloud-python'
DESCRIPTION='API Client library for Google Cloud'
SLOT='0'
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE='Apache-2.0'
SLOT='0'
KEYWORDS='~amd64'
IUSE=''

# TODO: dev-python/google-cloud(!core) should not be hard dependencies!
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
    dev-python/google-cloud-core[${PYTHON_USEDEP}]
    dev-python/google-cloud-bigquery[${PYTHON_USEDEP}]
    dev-python/google-cloud-bigtable[${PYTHON_USEDEP}]
    dev-python/google-cloud-datastore[${PYTHON_USEDEP}]
    dev-python/google-cloud-dns[${PYTHON_USEDEP}]
    dev-python/google-cloud-error-reporting[${PYTHON_USEDEP}]
    dev-python/google-cloud-language[${PYTHON_USEDEP}]
    dev-python/google-cloud-logging[${PYTHON_USEDEP}]
    dev-python/google-cloud-monitoring[${PYTHON_USEDEP}]
    dev-python/google-cloud-pubsub[${PYTHON_USEDEP}]
    dev-python/google-cloud-resource-manager[${PYTHON_USEDEP}]
    dev-python/google-cloud-runtimeconfig[${PYTHON_USEDEP}]
    dev-python/google-cloud-spanner[${PYTHON_USEDEP}]
    dev-python/google-cloud-speech[${PYTHON_USEDEP}]
    dev-python/google-cloud-storage[${PYTHON_USEDEP}]
    dev-python/google-cloud-translate[${PYTHON_USEDEP}]
    dev-python/google-cloud-videointelligence[${PYTHON_USEDEP}]
    dev-python/google-cloud-vision[${PYTHON_USEDEP}]
"

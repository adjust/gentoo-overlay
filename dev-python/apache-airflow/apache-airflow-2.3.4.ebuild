# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Apache Airflow"
HOMEPAGE="https://github.com/apache/airflow"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="+ftp +http +imap sqlite"

SLOT="0"

RESTRICT="test"

BDEPEND="
	dev-python/GitPython[${PYTHON_USEDEP}]
"
RDEPEND="
	dev-python/alembic[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	=dev-python/cattrs-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	<dev-python/colorlog-5[${PYTHON_USEDEP}]
	dev-python/connexion[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/cron-descriptor[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/dill[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-appbuilder[${PYTHON_USEDEP}]
	dev-python/flask-caching[${PYTHON_USEDEP}]
	dev-python/flask-login[${PYTHON_USEDEP}]
	dev-python/flask-session[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]
	dev-python/graphviz[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/importlib_metadata[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1.0[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/linkify-it-py[${PYTHON_USEDEP}]
	dev-python/lockfile[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/markdown-it-py[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/marshmallow-oneofschema[${PYTHON_USEDEP}]
	dev-python/mdit-py-plugins[${PYTHON_USEDEP}]
	dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	dev-python/pendulum[${PYTHON_USEDEP}]
	dev-python/pluggy[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/python-daemon[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-nvd3[${PYTHON_USEDEP}]
	dev-python/python-slugify[${PYTHON_USEDEP}]
	dev-python/sqlalchemy-jsonfield[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/semver[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	>dev-python/typing-extensions-4[${PYTHON_USEDEP}]
	dev-python/unicodecsv[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	www-servers/gunicorn[${PYTHON_USEDEP}]
"
PDEPEND="
	ftp? ( dev-python/apache-airflow-providers-ftp[${PYTHON_USEDEP}] )
	http? ( dev-python/apache-airflow-providers-http[${PYTHON_USEDEP}] )
	imap? ( dev-python/apache-airflow-providers-imap[${PYTHON_USEDEP}] )
	sqlite? ( dev-python/apache-airflow-providers-sqlite[${PYTHON_USEDEP}] )
"

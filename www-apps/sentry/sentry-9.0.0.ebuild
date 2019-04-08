# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Users and logs provide clues. Sentry provides answers."
HOMEPAGE="https://sentry.io/ https://pypi.org/project/sentry/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="$BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="optional"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/BeautifulSoup-3.2.1[${PYTHON_USEDEP}]
	=dev-python/boto3-1.4*[${PYTHON_USEDEP}]
	<dev-python/botocore-1.5.71[${PYTHON_USEDEP}]
	=dev-python/celery-3.1*[${PYTHON_USEDEP}]
	=dev-python/cffi-1.11.5[${PYTHON_USEDEP}]
	<dev-python/click-7.0[${PYTHON_USEDEP}]
	=dev-python/croniter-0.3.26[${PYTHON_USEDEP}]
	=dev-python/cssutils-0.9.9[${PYTHON_USEDEP}]
	=dev-python/django-crispy-forms-1.4.0[${PYTHON_USEDEP}]
	=dev-python/django-jsonfield-0.9.13[${PYTHON_USEDEP}]
	=dev-python/django-picklefield-0.3*[${PYTHON_USEDEP}]
	=dev-python/django-sudo-2.1*[${PYTHON_USEDEP}]
	>=dev-python/django-templatetag-sugar-0.1[${PYTHON_USEDEP}]
	=dev-python/Django-1.6.11[${PYTHON_USEDEP}]
	=dev-python/djangorestframework-2.4.8[${PYTHON_USEDEP}]
	=dev-python/email_reply_parser-0.2.0[${PYTHON_USEDEP}]
	=dev-python/enum34-1.1*[${PYTHON_USEDEP}]
	>=dev-python/exam-0.5.1[${PYTHON_USEDEP}]
	=dev-python/functools32-3.2.3[${PYTHON_USEDEP}]
	=dev-python/futures-3.2*[${PYTHON_USEDEP}]
	=dev-python/hiredis-0.1*[${PYTHON_USEDEP}]
	=dev-python/honcho-1.0*[${PYTHON_USEDEP}]
	=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]
	=dev-python/jsonschema-2.6.0[${PYTHON_USEDEP}]
	=dev-python/kombu-3.0.35[${PYTHON_USEDEP}]
	=dev-python/loremipsum-1.0.5[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.4.1[${PYTHON_USEDEP}]
	=dev-python/mistune-0.8*[${PYTHON_USEDEP}]
	=dev-python/mmh3-2.3.1[${PYTHON_USEDEP}]
	=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oauth2-1.5.167[${PYTHON_USEDEP}]
	=dev-python/parsimonious-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/percy-1.1.2[${PYTHON_USEDEP}]
	=dev-python/petname-2.0*[${PYTHON_USEDEP}]
	<=dev-python/pillow-4.2.1[${PYTHON_USEDEP}]
	=dev-python/progressbar2-3.10*[${PYTHON_USEDEP}]
	<dev-python/psycopg2-2.8.0[${PYTHON_USEDEP}]
	=dev-python/pyjwt-1.5*[${PYTHON_USEDEP}]
	=dev-python/pytest-django-2.9.1[${PYTHON_USEDEP}]
	=dev-python/pytest-html-1.9*[${PYTHON_USEDEP}]
	=dev-python/pytest-3.5*[${PYTHON_USEDEP}]
	<dev-python/python-dateutil-3.0.0[${PYTHON_USEDEP}]
	<dev-python/python-memcached-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-openid-2.2[${PYTHON_USEDEP}]
	=dev-python/python-u2flib-server-4.0.1[${PYTHON_USEDEP}]
	=dev-python/pyyaml-3.11*[${PYTHON_USEDEP}]
	=dev-python/qrcode-5.2.2[${PYTHON_USEDEP}]
	<dev-python/querystring_parser-2.0.0[${PYTHON_USEDEP}]
	=dev-python/rb-1.7[${PYTHON_USEDEP}]
	=dev-python/redis-py-cluster-1.3.4[${PYTHON_USEDEP}]
	=dev-python/redis-py-2.10.5[${PYTHON_USEDEP}]
	=dev-python/requests-oauthlib-0.3.3[${PYTHON_USEDEP}]
	=dev-python/requests-2.20*[ssl,${PYTHON_USEDEP}]
	=dev-python/selenium-3.11.0[${PYTHON_USEDEP}]
	<dev-python/semaphore-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/sentry-sdk-0.7.0[${PYTHON_USEDEP}]
	=dev-python/setproctitle-1.1.7[${PYTHON_USEDEP}]
	<dev-python/simplejson-3.9.0[${PYTHON_USEDEP}]
	=dev-python/six-1.10*[${PYTHON_USEDEP}]
	<dev-python/sqlparse-0.2.0[${PYTHON_USEDEP}]
	<dev-python/statsd-3.2.0[${PYTHON_USEDEP}]
	>=dev-python/strict-rfc3339-0.7[${PYTHON_USEDEP}]
	=dev-python/structlog-16.1.0[${PYTHON_USEDEP}]
	=dev-python/symbolic-5.8.1[${PYTHON_USEDEP}]
	=dev-python/toronado-0.0.11[${PYTHON_USEDEP}]
	<dev-python/ua-parser-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/unidiff-0.5.4[${PYTHON_USEDEP}]
	=dev-python/urllib3-1.24.1[${PYTHON_USEDEP}]
	<www-servers/uwsgi-2.1.0[${PYTHON_USEDEP}]
"

RESTRICT="test"

# DEPEND+="
# 	test? (
# 		dev-python/blist[${PYTHON_USEDEP}]
# 		<=dev-python/cassandra-driver-3.5.0[${PYTHON_USEDEP}]
# 		dev-python/casscache[${PYTHON_USEDEP}]
# 		dev-python/cqlsh[${PYTHON_USEDEP}]
# 		dev-python/datadog[${PYTHON_USEDEP}]
# 		=dev-python/freezegun-0.3.11[${PYTHON_USEDEP}]
# 		<dev-python/msgpack-python-0.5.0[${PYTHON_USEDEP}]
# 		=dev-python/pytest-cov-2.5*[${PYTHON_USEDEP}]
# 		=dev-python/pytest-timeout-1.2.1[${PYTHON_USEDEP}]
# 		=dev-python/pytest-xdist-1.18*[${PYTHON_USEDEP}]
# 		=dev-python/responses-0.8*[${PYTHON_USEDEP}]
# 		=dev-python/sqlparse-0.2.4[${PYTHON_USEDEP}]
# 	)
# "

RDEPEND="
	${DEPEND}
	optional? (
		=dev-python/confluent-kafka-0.11.5[${PYTHON_USEDEP}]
		=dev-python/geoip-python-1.3.2[${PYTHON_USEDEP}]
		=dev-python/google-cloud-pubsub-0.35*[${PYTHON_USEDEP}]
		=dev-python/google-cloud-storage-1.10.0[${PYTHON_USEDEP}]
		=dev-python/python3-saml-1.4*[${PYTHON_USEDEP}]
	)
"

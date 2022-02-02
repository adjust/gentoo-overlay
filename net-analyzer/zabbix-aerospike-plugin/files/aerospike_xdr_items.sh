#!/usr/bin/env bash
[[ $# -lt 3 ]] && exit -1
HOST="$1"
METRIC="$2"
DC="$3"
/usr/share/zabbix/externalscripts/aerospike_discovery.py -h ${HOST} -x ${DC} | jq '.data[] | select(."{#METRICNAME}" == "'$METRIC'") | ."{#METRICVALUE}"' | tr -d '"'

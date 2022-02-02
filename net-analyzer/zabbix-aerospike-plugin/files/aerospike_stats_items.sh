#!/usr/bin/env bash
[[ $# -ne 2 ]] && exit -1
HOST="$1"
METRIC="$2"
/usr/share/zabbix/externalscripts/aerospike_discovery.py -h ${HOST} | jq '.data[] | select(."{#METRICNAME}" == "'$METRIC'") | ."{#METRICVALUE}"' | tr -d '"'

#!/usr/bin/env bash
[[ $# -ne 3 ]] && exit -1
HOST="$1"
METRIC="$2"
NAMESPACE="$3"
/usr/share/zabbix/externalscripts/aerospike_discovery.py -h ${HOST} -n ${NAMESPACE} | jq '.data[] | select(."{#METRICNAME}" == "'$METRIC'") | ."{#METRICVALUE}"' | tr -d '"'

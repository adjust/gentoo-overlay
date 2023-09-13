#!/bin/bash

# directory where the base runner image is stored
BASENAME=base

# default interval in seconds between status checks
# (see -i parameter below)
INTERVAL=30

# parallel runners
# (see -n parameter below)
MAXRUNNERS=5

# Add user local pip binary path to PATH
# This is required for ansible purposes
export PATH=${HOME}/.local/bin:${PATH}

TMP_TOKEN=""
TMP_TOKEN_EXP=""
TMP_TOKEN_LEFT=120
CURL_RESULT=""
DEBUG=false
EXTRA_LABELS="default"

# parse command line args
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -sd)
      SRCDIR="$2"
      shift 2
      ;;
    -rt)
      RUNNERTAG="$2"
      shift 2
      ;;
    -gt)
      GHTOKEN="$2"
      shift 2
      ;;
    -gr)
      GHREPO="$2"
      shift 2
      ;;
    -i)
      INTERVAL="$2"
      shift 2
      ;;
    -n)
      MAXRUNNERS="$2"
      shift 2
      ;;
    -d)
      DEBUG=true
      shift
      ;;
    -l)
      EXTRA_LABELS="$2"
      shift
      ;;
    *)
      shift
      ;;
  esac
done
if [ "${SRCDIR}" == "" ] || [ "${RUNNERTAG}" == "" ] || [ "${GHTOKEN}" == "" ] || [ "${GHREPO}" == "" ] ; then
    echo "Usage: $0 -sd <working dir> -rt <runner tag> -gt <github token> -gr <github repo> [ -i <interval> -n <max runners> -l <additional labels> -d ] "
    exit 1
fi

# prefix for the runner name
# name will be like 'runner_tag_XXXXXX'
DSTPREFIX=runner_${RUNNERTAG}_

# runners directory
RUNNERDIR=${SRCDIR}/dynamic

# logging function
# second parameter can be "d" which means 'debug message'
# debug messages are visible in debug mode, i.e. with '-d' cmdline flag
function log() {
    if [ "$2" == "d" ]; then
	if ${DEBUG}; then
	    echo $(date +"[%Y-%m-%d %H:%M:%S]") DEBUG: $1
	fi
    else
	echo $(date +"[%Y-%m-%d %H:%M:%S]") $1
    fi
}

# wrapper for curl, adds headers and stores the return value
function _curl() {
    CMD=$1
    END=$2
    CURL_RESULT=$(curl -s -u "${GHTOKEN}" -X ${CMD} -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${GHREPO}/actions/runners${END})
}

# create a runner control token
# token is valid for one hour so this function reuses the
# token if it's not yet expired
function tmptoken() {
    RENEW=true
    if [ -n "${TMP_TOKEN}" ]; then
	RENEW=false
	NOW=$(date +%s)
	VALID=$((TMP_TOKEN_EXP-NOW))
	if [ "${VALID}" -lt "${TMP_TOKEN_LEFT}" ]; then RENEW=true; fi
    fi
    if ${RENEW}; then
	_curl "POST" "/registration-token"
	TMP_TOKEN=$(echo ${CURL_RESULT} | jq .token -r)
	TMP_TOKEN_EXP=$(echo ${CURL_RESULT} | jq -r .expires_at | date -f- +%s)
	log "TMP_TOKEN: acquired" "d"
    else
	log "TMP_TOKEN: reused" "d"
    fi
}

# clone the runner from the base image
# it uses the random name and creates all the files required
# to save disk space files are not copied, they are
# hardlinked instead
function clone_runner() {
    DSTSUFFIX=$(echo $RANDOM | md5sum | head -c 6) # 6 random HEX digits
    DSTDIR=${RUNNERDIR}/${DSTPREFIX}${DSTSUFFIX}
    log "Creating directory structure for ${DSTPREFIX}${DSTSUFFIX}..." "d"
    { cd ${SRCDIR}/${BASENAME} && find . -type d ;} | xargs -i mkdir -p ${DSTDIR}/{}
    log "Hard-linking files..." "d"
    { cd ${SRCDIR}/${BASENAME} && find . -type f ;} | xargs -i ln ${SRCDIR}/${BASENAME}/{} ${DSTDIR}/{}
    log "Creating GitHub service token..." "d"
    { cd ${DSTDIR} && ./config.sh --unattended --ephemeral --labels ${EXTRA_LABELS} --name ${DSTPREFIX}${DSTSUFFIX} --url https://github.com/${GHREPO} --token ${TMP_TOKEN} ;}
    log "Starting runner ${DSTPREFIX}${DSTSUFFIX}"
    ${DSTDIR}/run.sh &
}

# unregisters the local runner from github
# uses the runner tools
# (keeps directory and files)
function unregister_runner() {
    log "LOCAL: invoking 'config.sh remove' for ${RUNNERDIR}/$1" "d"
    { cd ${RUNNERDIR}/$1 && ./config.sh remove --token ${TMP_TOKEN} ;}
}

# delete local directory
# we assume the runner is stopped and unregistered
function delete_local_runner() {
    log "LOCAL: trying to stop orphaned runner $1" "d"
    kill `pgrep -f $1` 2>/dev/null
    log "LOCAL: delete runner $1"
    rm -rf ${RUNNERDIR}/$1
}

# force unregister the runner on GH
function delete_gh_runner() {
    log "GH: deleting runner #$1"
    _curl "DELETE" "/$1"
}

# gently remove all the local runners
function rm_runners() {
    if [ -d ${RUNNERDIR} ]; then
	for r in `{ cd ${RUNNERDIR} && ls -d */ 2>/dev/null | cut -f1 -d'/';}`; do
		unregister_runner ${r}
		delete_local_runner ${r}
        done
    fi
}

# function that is called on SIGEXIT
# removes all the runners and exits
trap cleanup EXIT
function cleanup() {
    log "Performing cleanup"
    rm_runners
    log "Exiting"
    exit
}

# check for the version update
# it's important to have the latest version of a runner
# otherwise it fails
function update_check() {
    log "Checking for update" "d"
    DIR="${SRCDIR}/${BASENAME}"
    VERFILE="${DIR}/.ver"

    if [ ! -d ${DIR} ]; then mkdir ${DIR}; fi
    if [ ! -f "${VERFILE}" ]; then
        CURRENT="0"
    else
        CURRENT=$(cat ${VERFILE})
    fi

    # get the json with the latest information and parse it
    LATEST=`curl -s -u ${GHTOKEN} https://api.github.com/repos/actions/runner/releases/latest`
#    URL=`echo ${LATEST} | jq -r '.assets[].browser_download_url|select(.|contains("linux-x64"))'`
# object structure is changed, it's a list of URLs now and the last one is what we need
    URL=`echo ${LATEST} | jq -r '[.assets[].browser_download_url|select(.|contains("linux-x64"))]|last'`
    VER=`echo ${LATEST} | jq -r '.name'`

    if [ ! "${CURRENT}" == "${VER}" ]; then
    	# update: download the new one and delete the old one. no sorrow.
	log "Versions are different, updating ${CURRENT} -> ${VER}..."
	rm -rf ${DIR}.tmp # to be sure
	mkdir ${DIR}.tmp
	wget -qO- ${URL} | tar xfz - -C ${DIR}.tmp
	mv ${DIR} ${DIR}.bak
	mv ${DIR}.tmp ${DIR}
	rm -rf ${DIR}.bak
	echo -n "${VER}" > ${VERFILE}
	log "Updated to ${VER}. Removing outdated runners..." "d"
	rm_runners
    else
        log "Use version ${VER}" "d"
    fi
}

# main function of the supervisor
function main() {
    log "Starting supervisor: GH repo ${GHREPO}, query interval: ${INTERVAL} sec, ${MAXRUNNERS} parallel runners"
    log "Debug mode: ON" "d"
    while true
    do
	update_check
	# declare variables as associative arrays
	declare -A RUNNERS
	declare -A RUNNER_IDS
	tmptoken
	# first local cleanup
	if [ -d ${RUNNERDIR} ]; then
	    LOCAL_RUNNERS=`{ cd ${RUNNERDIR} && ls -d */ 2>/dev/null | cut -f1 -d'/';}`
	else
	    LOCAL_RUNNERS=""
	fi
	# weird situation: runner is working but it's dir is deleted
	# almost impossible but who knows
	# we need to stop that
	# we kill only runners with the current RUNNERTAG
	# to allow other supervisors to do their job
	for run in `ps -o args= -C Runner.Listener | grep ${DSTPREFIX} | rev | cut -d'/' -f 3 | rev`; do
	    if [ ! -d ${RUNNERDIR}/$run ]; then
		log "No directory for process $run, stopping it" "d"
		kill `pgrep -f $run`
	    fi
	done
	log "Fetching GH state..." "d"
	# get the json with runners state
	_curl "GET" ""
	GR_STATE=${CURL_RESULT}
	# use only self-hosted runners
	GR_SELF=`echo ${GR_STATE} | jq '[.runners[]|select((.labels[].name|contains("self-hosted")) and (.name|contains("'${DSTPREFIX}'")))]'`
	GR_COUNT=$(echo ${GR_SELF} | jq "length")
	GR_COUNT="${GR_COUNT:-0}"
	for (( i=0; i<${GR_COUNT}; i++ )) do
	    GR_NAME=$(echo ${GR_SELF} | jq -r ".[${i}].name")
	    GR_STATUS=$(echo ${GR_SELF} | jq -r ".[${i}].status")
	    GR_ID=$(echo ${GR_SELF} | jq -r ".[${i}].id")
	    RUNNERS[${GR_NAME}]=${GR_STATUS}
	    RUNNER_IDS[${GR_NAME}]=${GR_ID}
	done
	log "Got GH state: ${GR_COUNT} runners configured" "d"
	log "Checking local system..." "d"
	OK=0
	# compare GH state with local state
	# and remove all the discrepancies
	for r in ${LOCAL_RUNNERS}; do
	    if [ ${RUNNERS[${r}]+_} ]; then
		if [ "${RUNNERS[${r}]}" == "offline" ]; then
		    log "Runner ${r} is offline. Unregistering and removing..." "d"
		else
		    log "Runner ${r} is ${RUNNERS[${r}]}" "d"
		    OK=$((OK+1))
		fi
		unset RUNNERS[$r]
	    else
		log "Runner ${r} not found on GH. Deleting locally..." "d"
		delete_local_runner ${r}
	    fi
	done
	# if there are GH runners left it means something was broken locally
	# just delete broken GH runner
	for key in "${!RUNNERS[@]}"; do
	    log "No local runner for ${key} #${RUNNER_IDS[$key]}. Deleting on GH..." "d"
	    delete_gh_runner ${RUNNER_IDS[$key]} ${RUNNERS[${r}]}
	done
	log "$OK runners of ${MAXRUNNERS} are in the valid state" "d"
	# create as many new runners as required
	for ((i=$OK; i<${MAXRUNNERS}; i++)) do
	    clone_runner
	done
	unset RUNNERS
	unset RUNNER_IDS
	sleep ${INTERVAL}
    done
}

main

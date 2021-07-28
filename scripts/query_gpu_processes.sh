#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

query_gpu_processes()
{
    declare -r pids="$(nvidia-smi --query-compute-apps=pid --format=csv,noheader)"
    if [ ! -z "${pids}" ]; then
        declare -r pids_info=$(ps -ww -o pid,user,etime,command --pid ${pids})
        declare -r info=${pids_info//$'\n'/ $'\n\n'}
        # printf "${pids_info}\n"
        printf "${info}\n"
    else
        printf "No running GPU processes.\n"
    fi
}

query_gpu_processes ${@}

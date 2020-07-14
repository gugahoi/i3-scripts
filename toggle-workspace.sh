#!/usr/bin/env bash
#
# This script will toggle the location of the workspace between the current 
# active monitors.

set -euo pipefail

outputs=( $(i3-msg -t get_outputs | \
    jq  '.[] | select(.active == true) | .name | select(. != "xroot-0")') )
echo "found displays: ${outputs[@]}"

current="$(i3-msg -t  get_workspaces | \
    jq '.[] | select(.focused == true) | {name: .name, output: .output}')"

curr_output="$(echo "${current}" | jq '.output')"
curr_workspace="$(echo "${current}" | jq '.name')"
echo "current display: ${curr_output}"
echo "current workspace: ${curr_workspace}"

for index in "${!outputs[@]}"; do 
    if [[ "${outputs[$index]}" = "${curr_output}" ]]; then
        let next_position=$index+1
    fi
done

[ "$next_position" -ge ${#outputs[@]} ] && next_position=0
echo "sending workspace to output: ${outputs[next_position]}"
i3-msg "move workspace to output ${outputs[next_position]}"

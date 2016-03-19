#!/usr/bin/env bash
#
# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "[error] Both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be defined." >&2
    exit 1
fi

if [ ! $(command -v packer) ]; then
    echo "[error] You do not appear to have packer installed." >&2
    echo "[error] See: https://packer.io/downloads" >&2
    exit 1
fi

function handle_error () {
  echo "[error] Got a return code of $? on line $1." >&2
  echo "[error] The build did not complete successfully." >&2
  exit 1
}

trap 'handle_error $LINENO' ERR

set -o pipefail

build_start_time="$(date +'%s')"

pushd "$(dirname "$0")" > /dev/null


# If jsmin is installed, use it to strip comments from the template.
if [ $(command -v jsmin) ]; then
    echo "[info] Detected jsmin. Will use it to pre-process JSON template before handing it off to Packer."
    template='jsmin < "./spark-packer-template.json"'
else
    template='cat "./spark-packer-template.json"'
fi

# Build the AMIs and simultaneously pipe the output to a log
#+ and to an awk script that will filter in only the artifact IDs
#+ for further processing.

packer build <(eval "$template") -machine-readable \
    | tee "build.log" \
        >(
            awk -F "," '{
                if (($3 == "artifact") && ($5 == "id")) {
                    print $0
                }
            }' > "output.csv"
        )

ami_count=$(
    awk -F "," '{
        split($6, artifact_ids, "\\%\\!\\(PACKER\\_COMMA\\)")
        
        for (i in artifact_ids) {
            print artifact_ids[i]
        }
    }' "./output.csv" | wc -l | tr -d ' '
)

echo ""
echo "Successfully registered $ami_count AMIs."

popd > /dev/null

build_end_time="$(date +'%s')"

diff_secs="$(($build_end_time-$build_start_time))"
build_mins="$(($diff_secs / 60))"
build_secs="$(($diff_secs - $build_mins * 60))"

echo ""
echo "Build completed successfully in: ${build_mins}m ${build_secs}s."

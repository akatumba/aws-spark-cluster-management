#!/usr/bin/env bash
#
# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

source ~/.profile

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "[error] Both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be defined." >&2
    exit 1
fi

function handle_error () {
  echo "[error] Encountered a return code of $? on line $1." >&2
  echo "[error] The build did not complete successfully." >&2
  exit 1
}

trap 'handle_error $LINENO' ERR

set -o pipefail

build_start_time="$(date +'%s')"

pushd "$(dirname "$0")" > /dev/null

# Ensure we're up-to-date
sudo apt-get -y update

# Options:
# --force-confdef: Force to keep default option without prompting. 
# --force-confold: Force to keep old conf files.
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confnew" --force-yes upgrade

# Download and decompress our custom Spark build.
cd $HOME
spark_version="${X_SPARK_VERSION:-1.6.1}"
wget --no-check-certificate http://resources.sixafter.com/spark-${spark_version}-bin-custom.tgz
mkdir spark
tar -xf spark-${spark_version}-bin-custom.tgz -C ./spark --strip-components=1

# Move the slave information in place.
if [ -a /tmp/slaves ]; then 
  sudo mv /tmp/slaves spark/conf/
fi

popd > /dev/null

build_end_time="$(date +'%s')"

diff_secs="$(($build_end_time-$build_start_time))"
build_mins="$(($diff_secs / 60))"
build_secs="$(($diff_secs - $build_mins * 60))"

echo ""
echo "Build completed successfully in: ${build_mins}m ${build_secs}s"


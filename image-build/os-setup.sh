#!/bin/bash
#
# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

set -e

# Both of these can be problematic.
sudo apt-get update -y
# sudo apt-get upgrade -y

sudo apt-get install -y build-essential

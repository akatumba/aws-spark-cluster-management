#!/bin/bash
#
# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

# Prerequisites.
sudo apt-get install -y gcc

# Python 2.7
sudo apt-get install -y python python-dev python-software-properties python-pip
sudo apt-get install -y automake libtool g++ protobuf-compiler libprotobuf-dev libboost-dev libutempter-dev libncurses5-dev zlib1g-dev libio-pty-perl libssl-dev pkg-config

#!/bin/bash
#
# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

sudo sed --in-place -r "s/(^disable_root:) (true)/\1 false/g" /etc/cloud/cloud.cfg
sudo sed --in-place -r "0,/^\#PermitRootLogin/s/^\#(PermitRootLogin) (.*)/\1 without-password/g" /etc/ssh/sshd_config

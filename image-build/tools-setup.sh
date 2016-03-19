#!/bin/bash`
#
# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

# Creates an AMI for the Spark EC2 scripts based on Ubuntu

set -e

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# Developer Tools
sudo apt-get install -y  gcc ant git

# Install Open JDK 7 and JRE 7
sudo apt-get install -y openjdk-7-jdk
sudo apt-get install -y openjdk-7-jre

# Install Open JDK 8 and JRE 8
sudo add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get update -y 
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install -y openjdk-8-jre

# Install Oracle JDK and JRE
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update -y 
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java8-installer

# Automatically set up the Java 8 environment variables
sudo apt-get install -y oracle-java8-set-default

# Ganglia and misc tools
sudo apt-get install -y pssh git
sudo apt-get install -y xfsprogs
sudo apt-get install -y ntp
sudo apt-get install -y wget

# Install Ganglia

# Ganglia extra modules for Linux (IO, filesystems, multicpu)
sudo apt-get install -y ganglia-modules-linux 
# cluster monitoring toolkit - node daemon
sudo apt-get install -y ganglia-monitor
# cluster monitoring toolkit - python modules
sudo apt-get install -y ganglia-monitor-python
# cluster monitoring toolkit - web front-end 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ganglia-webfrontend
# cluster monitoring toolkit - Ganglia Meta-Daemon
sudo apt-get install -y gmetad 

# nginx
# sudo apt-get install nginx-full

# Install GNU parallel.
{
    pushd /tmp
    PARALLEL_VERSION="20160222" 
    wget "http://ftpmirror.gnu.org/parallel/parallel-${PARALLEL_VERSION}.tar.bz2"
    bzip2 -dc "parallel-${PARALLEL_VERSION}.tar.bz2" | tar xvf -
    pushd "parallel-${PARALLEL_VERSION}"
    ./configure --prefix=/usr  # Amazon Linux root user doesn't have /usr/local on its $PATH
    make
    sudo make install
    popd
    rm -rf "./parallel-${PARALLEL_VERSION}*"
    popd

    # Suppress citation notice.
    echo "will cite" | parallel --bibtex
}

# Performance Tools
sudo apt-get install -y dstat iotop strace sysstat htop

# PySpark and MLlib dependencies.
sudo apt-get install -y python-matplotlib python-tornado

# SparkR dependencies.
sudo apt-get install -y r-base

# Create /usr/bin/realpath which is used by R to find Java installations
sudo apt-get install -y realpath

# Root ssh config
sudo sed -i 's/PermitRootLogin.*/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sudo sed -i 's/disable_root.*/disable_root: 0/g' /etc/cloud/cloud.cfg

# Set up ephemeral mount points.
sudo sed -i 's/mounts.*//g' /etc/cloud/cloud.cfg
sudo sed -i 's/.*ephemeral.*//g' /etc/cloud/cloud.cfg
sudo sed -i 's/.*swap.*//g' /etc/cloud/cloud.cfg

echo "mounts:" >> /etc/cloud/cloud.cfg
echo " - [ ephemeral0, /mnt, auto, \"defaults,noatime,nodiratime\", "\
  "\"0\", \"0\" ]" >> /etc/cloud.cloud.cfg

for x in {1..23}; do
  echo " - [ ephemeral$x, /mnt$((x + 1)), auto, "\
    "\"defaults,noatime,nodiratime\", \"0\", \"0\" ]" >> /etc/cloud/cloud.cfg
done

source ~/.profile

# Install Maven (for Hadoop)
sudo apt-get install -y maven

# Build Hadoop to install native libraries.
sudo mkdir /root/hadoop-native
cd /tmp
hadoop_version="2.7.2"
sudo apt-get install -y protobuf-compiler cmake openssl
wget "http://archive.apache.org/dist/hadoop/common/hadoop-${hadoop_version}/hadoop-${hadoop_version}-src.tar.gz"
tar xvzf "hadoop-${hadoop_version}-src.tar.gz"
cd "hadoop-${hadoop_version}-src"
mvn package -Pdist,native -DskipTests -Dtar
sudo mv "hadoop-dist/target/hadoop-${hadoop_version}/lib/native/"* /root/hadoop-native

# Install Snappy library (for Hadoop).
apt-get install -y snappy
ln -sf /usr/lib64/libsnappy.so.1 /root/hadoop-native/.


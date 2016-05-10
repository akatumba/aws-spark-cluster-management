# Copyright (c) 2016 Six After, Inc. All Rights Reserved. 
#
# Use of this source code is governed by the Apache 2.0 license that can be
# found in the LICENSE file in the root of the source
# tree.

variable "aws_access_key" {
  description = "AWS access key."
}

variable "aws_secret_key" {
  description = "AWS secret key."
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-1"
}

variable "ssh_key_name" {
  description = "The SSH key name to use for the instances."
  default = "sixafter-deployer"
}

variable "ssh_key_path" {
  description = "Path to the SSH private key file."
  default = "~/.ssh/six-after/us-west-1/sixafter-deployer.pem"
}

variable "aws_ssh_user" {
  description = "SSH user."
  default = "ubuntu"
}

variable "vpc_cidr_block" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "172.31.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "172.31.0.0/20"
}

variable "private_subnet_cidr_block" {
  description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
  default = "172.31.16.0/20"
}

# Ubuntu Server 14.04 LTS x64 (HVM) 
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-4756d334"
    us-east-1 = "ami-b91b19d3"
    us-west-1 = "ami-294e3c49"
    us-west-2 = "ami-ab8a62cb"
  }
}

/*
 * Source: http://aws.amazon.com/amazon-linux-ami/instance-type-matrix/
 * We're currently interested in only a few instance types and specifically only in HVMs. PVMs are not supported 
 * for our configurations: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html.
 * 
 * t2.micro
 * t2.small
 * t2.medium
 * t2.large
 * m4.large
 * m4.xlarge
 * m4.2xlarge
 * m4.4xlarge
 * m4.10xlarge
 * c4.4xlarge
 * c4.8xlarge
 */
variable "aws_ec2_instance_type" {
  description = "AWS instance type."
  default = "t2.large"
}

# Ubuntu Server 14.04 LTS x64 (HVM).
variable "ebs_optimized" {
  default = {
    t2.micro = false
    t2.small = false
    t2.medium = false
    t2.large = false
    m4.large = true
    m4.xlarge = true
    m4.2xlarge = true
    m4.4xlarge = true
    m4.10xlarge = true
    c4.4xlarge = true
    c4.8xlarge = true
  }
}

variable "cluster_name" {
  description = "The canonical name of the Spark cluster."
}

variable "cluster_size" {
  description = "The size of the Spark cluster in terms of number of nodes excluding the master node."
  default = 10
}


# Spark Image Build Scripts

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://github.com/sixafter/aws-spark-cluster-management/blob/master/LICENSE)

These scripts use [Packer](http://www.packer.io/) to create and register a set of AMIs that includes all the software we need to quickly launch Spark clusters on EC2 using the latest US-West-1 EBS-backed Ubuntu AMI as a base. The generated AMIs are registered under the Amazon account associated with the AWS credentials set in your operating system's environment.

## Usage

Execute the following script. 

```sh
./build_spark_amis.sh
```

## Generated AMIs

The script`build_spark_amis.sh` creates a single EBS-backed AMI for the set of AWS zones defined in `spark-packer-template.json`. Search for the term "ami_regions".

### Base Spark AMI

Currently, a single logical Amazon Machine Image (AMI) is generated containg the critical dependencies and miscellaneous tools for Apache Spark and `spark-submit`. 

This AMI includes:

  * Oracle Java JDK 1.8 and Oracle Java JRE 1.8
  * * [OpenJDK 1.7](http://openjdk.java.net/projects/jdk7/) and OpenJRE 1.7.
  * [OpenJDK 1.8](http://openjdk.java.net/projects/jdk8/) and OpenJRE 1.8
  * Python 2.7
  * R
  * Maven
  * Ganglia
  * Useful tools like `pssh`

This AMI *does not* include:

* [Apache Spark](http://spark.apache.org)
* [Apache Hadoop](http://hadoop.apache.org)
* [Alluxio](http://alluxio.org). This project was formerly known as Tachyon. 

### AMI Virtualization Type

Linux Amazon Machine Images use one of two types of virtualization: paravirtual (PV) or hardware virtual machine (HVM). The main difference between PV and HVM AMIs is the way in which they boot and whether they can take advantage of special hardware extensions (CPU, network, and storage, and GPU extensions) for better performance.  

For more information on Linux AMI virtualization types, see the [latest AWS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html).

The current template specifies the Hardware Virtual Machine (HVM) AMI virtualization type only. You can modify the .json [Packer](http://packer.io) template to include the Paravirtual (PV) AMI virtualization type.

### Elastic Compute Cloud (EC2) Regions

The following [EC2 regions](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html) are covered by these scripts.

1. `eu-west-1` - EU (Ireland)
2. `us-east-1` - US East (N. Virginia)
3. `us-west-1` - US West (N. California)
4. `us-west-2` - US West (Oregon)

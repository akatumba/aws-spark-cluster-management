
# Apache Spark AMI and AWS Cluster Management 

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

The scripts provide support for Amazon Web Services (AWS) AMI image and EC2 cluster management for Apache Spark using [Packer](http://packer.io) and [Terraform](http://terraform.io), respectively.

Before using these scripts, take a quick look at the [copyright](COPYRIGHT) notice and [license](LICENSE) to ensure their terms are acceptable.

## Installation

Ensure you have an [Amazon AWS account](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html) and the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables are configured.

**Linux, OS X, or Unix**

```sh
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENGbPxRfiCYEXAMPLEKEY
```

## Usage

See the [image build](image-build/README.md) and [cluster-build](cluster-build/README.md) README files.

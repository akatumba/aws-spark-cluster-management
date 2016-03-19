/*
 * If a variable is named "amazon_key", then set the TF_VAR_amazon_key environment variable
 * so Terraform will inherit the value. See https://www.terraform.io/docs/providers/aws/.
 */

ssh_key_path = "~/.ssh/us-west-1/sixafter-deployer.pem"
ssh_key_name = "sixafter-deployer"
aws_region = "us-west-1"
cluster_name = "spark-cluster-1"
cluster_size = 1
aws_ec2_instance_type = "t2.micro"

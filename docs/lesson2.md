# Lesson 102 AWS Authentication and Endpoints

In the previous example there was no Auth as there was no Cloud API/Provider.

## pre-requisites

- aws account
- iam user and access keys

Setting up basic Auth for AWS/Terraform.

- Install aws-cli
- Install aws auth using you access keys

```cli
$ aws configure
AWS Access Key ID [****************ZTLA]:
AWS Secret Access Key [****************Z5Pj]:
Default region name [eu-west-1]:
Default output format [json]:
```

## Test Auth

You can test your AWS authentication with a basic AWS command:

```cli
aws s3 ls
```

If that is successful we can progress to out task.

## Provisioning an VPC Endpoint for S3 - PrivateLink

A provisioned PrivateLink means that all traffic is routed private to the endpoint rather than over the internet.

### Add the Provider

Create **provider.aws.tf**

```terraform
provider "aws" {
  region  = "eu-west-1"
  version = "2.54"
}
```

This completes you basic Authentication for AWS and Terraform.
Test with:

```cli
Terraform init
Terraform apply
```

## Datasources

To Add a VPC endpoint we first need to gather some basic information from the account, datasources are used for this **data.tf**:

```terraform
data "aws_vpcs" "cluster" {}
data "aws_region" "current" {}
```

This will give ALL the VPC's is region as well as the current region.

## Create and AWS resource

Add the code to create the S3 Endpoint **aws_vpc_endpoint.s3.tf**:

```terraform
resource "aws_vpc_endpoint" "s3" {

  vpc_id       = element(tolist(data.aws_vpcs.cluster.ids), 0)
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = {
  "createdby" = "Terraform"
  "Name"      = "S3"}
}
```

!!! note "Takeaways" - blah

## Exercise

1.

## Questions

1. What is missing from this to set up access for an EC2 instance to use the Private Link?

- There's no route, modification to the routeables is required.

## Documentation

For more on null resource see the Hashicorp docs:
<https://www.terraform.io/docs/providers/null/resource.html>

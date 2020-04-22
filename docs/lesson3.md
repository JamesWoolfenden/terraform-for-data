# Lesson 102 AWS Authentication and Endpoints

In the previous example there was no Auth as there was no Cloud API/Provider.

## pre-requisites

- an AWS account
- IAM user with access keys

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
2020-04-09 09:38:42 elasticbeanstalk-eu-west-1-680235478471
2020-04-09 09:38:08 whosebucketisitanyway
```

If that is successful we can progress to our task.

## VPC Endpoint for S3 - PrivateLink

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

### Datasources

To add a VPC endpoint, we first need to gather some basic information from the account, datasources are very useful for this, create **data.tf**:

```terraform
data "aws_vpcs" "cluster" {}
data "aws_region" "current" {}
```

This will return ALL the VPC's is a region as well as what the current region is.

### Create and AWS resource

Add the code to create the S3 Endpoint **aws_vpc_endpoint.s3.tf**:
This uses values from the datasources.

```terraform
resource "aws_vpc_endpoint" "s3" {

  vpc_id       = element(tolist(data.aws_vpcs.cluster.ids), 0)
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

  tags = {
  "createdby" = "Terraform"
  "Name"      = "S3"}
}
```

element(tolist(data.aws_vpcs.cluster.ids), 0) will cast to a list and then return the element of the list at 0 - a vpc_id.

\${data.aws_region.current.name} will be replaced in Terraform by my aws region **eu-west-1**.

As you will see when you Terraform apply:

```terraform apply
$ terraform apply
data.aws_region.current: Refreshing state...
data.aws_vpcs.cluster: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc_endpoint.s3 will be created
  + resource "aws_vpc_endpoint" "s3" {
      + cidr_blocks           = (known after apply)
      + dns_entry             = (known after apply)
      + id                    = (known after apply)
      + network_interface_ids = (known after apply)
      + owner_id              = (known after apply)
      + policy                = (known after apply)
      + prefix_list_id        = (known after apply)
      + private_dns_enabled   = false
      + requester_managed     = (known after apply)
      + route_table_ids       = (known after apply)
      + security_group_ids    = (known after apply)
      + service_name          = "com.amazonaws.eu-west-1.s3"
      + state                 = (known after apply)
      + subnet_ids            = (known after apply)
      + tags                  = {
          + "Name"      = "S3"
          + "createdby" = "Terraform"
        }
      + vpc_endpoint_type     = "Gateway"
      + vpc_id                = "vpc-510efa34"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc_endpoint.s3: Creating...
aws_vpc_endpoint.s3: Creation complete after 6s [id=vpce-0340fd0233d361bde]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

endpoint = {
  "cidr_blocks" = [
    "52.218.0.0/17",
  ]
  "dns_entry" = []
  "id" = "vpce-0340fd0233d361bde"
  "network_interface_ids" = []
  "owner_id" = "680235478471"
  "policy" = "{\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":\"*\"}],\"Version\":\"2008-10-17\"}"
  "prefix_list_id" = "pl-6da54004"
  "private_dns_enabled" = false
  "requester_managed" = false
  "route_table_ids" = []
  "security_group_ids" = []
  "service_name" = "com.amazonaws.eu-west-1.s3"
  "state" = "available"
  "subnet_ids" = []
  "tags" = {
    "Name" = "S3"
    "createdby" = "Terraform"
  }
  "vpc_endpoint_type" = "Gateway"
  "vpc_id" = "vpc-510efa34"
}
```

!!! note "Takeaways"

- datasources
- token replacement
- casting and indexing of lists

## Exercise

1. Add outputs so that you can see all the values for the created resource.

## Questions

1. What is missing from this to set up access for an EC2 instance to use the Private Link?

- There's no route, a modification to the route-able is still required.

## Documentation

For more on null resource see the Hashicorp docs:
<https://www.terraform.io/docs/providers/null/resource.html>

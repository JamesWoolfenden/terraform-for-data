# Lesson 101 Introduction and Hello World

## Introduction to Terraform

What is Terraform?

It's an open-source command line tool for creating infrastructure.

Terraform is a declarative second generation Configuration Management tool designed to provision cloud based Infrastructure via Code.

What does that mean?

It's easier to show you the difference between using the Traditional approach using the CLI and Terraform.

First up is creating an AWS EC2 instance via the CLI.

```cli
$ aws ec2 run-instances --image-id ami-7ad7c21e --count 1 --instance-type t2.micro --key-name basic --region eu-west-2 --subnet-id subnet-05f8f3c120238ca8d
{
    "Groups": [],
    "Instances": [
        {
            "AmiLaunchIndex": 0,
            "ImageId": "ami-7ad7c21e",
            "InstanceId": "i-0529e7f9f72b02a53",
            "InstanceType": "t2.micro",
            "KeyName": "basic",
            "LaunchTime": "2020-04-21T13:28:11.000Z",
            "Monitoring": {
                "State": "disabled"
            },
            "Placement": {
                "AvailabilityZone": "eu-west-2a",
                "GroupName": "",
                "Tenancy": "default"
            },
            "PrivateDnsName": "ip-10-0-0-187.eu-west-2.compute.internal",
            "PrivateIpAddress": "10.0.0.187",
            "ProductCodes": [],
            "PublicDnsName": "",
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "StateTransitionReason": "",
            "SubnetId": "subnet-05f8f3c120238ca8d",
            "VpcId": "vpc-0e2e925de622375b5",
            "Architecture": "x86_64",
            "BlockDeviceMappings": [],
            "ClientToken": "",
            "EbsOptimized": false,
            "Hypervisor": "xen",
            "NetworkInterfaces": [
                {
                    "Attachment": {
                        "AttachTime": "2020-04-21T13:28:11.000Z",
                        "AttachmentId": "eni-attach-0cbcd67ab97add978",
                        "DeleteOnTermination": true,
                        "DeviceIndex": 0,
                        "Status": "attaching"
                    },
                    "Description": "",
                    "Groups": [
                        {
                            "GroupName": "default",
                            "GroupId": "sg-05749b21616ab0cdc"
                        }
                    ],
                    "Ipv6Addresses": [],
                    "MacAddress": "06:2c:00:49:c8:64",
                    "NetworkInterfaceId": "eni-0898a0bee39c83400",
                    "OwnerId": "680235478471",
                    "PrivateDnsName": "ip-10-0-0-187.eu-west-2.compute.internal",
                    "PrivateIpAddress": "10.0.0.187",
                    "PrivateIpAddresses": [
                        {
                            "Primary": true,
                            "PrivateDnsName": "ip-10-0-0-187.eu-west-2.compute.internal",
                            "PrivateIpAddress": "10.0.0.187"
                        }
                    ],
                    "SourceDestCheck": true,
                    "Status": "in-use",
                    "SubnetId": "subnet-05f8f3c120238ca8d",
                    "VpcId": "vpc-0e2e925de622375b5",
                    "InterfaceType": "interface"
                }
            ],
            "RootDeviceName": "/dev/sda1",
            "RootDeviceType": "ebs",
            "SecurityGroups": [
                {
                    "GroupName": "default",
                    "GroupId": "sg-05749b21616ab0cdc"
                }
            ],
            "SourceDestCheck": true,
            "StateReason": {
                "Code": "pending",
                "Message": "pending"
            },
            "VirtualizationType": "hvm",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 1
            },
            "CapacityReservationSpecification": {
                "CapacityReservationPreference": "open"
            },
            "MetadataOptions": {
                "State": "pending",
                "HttpTokens": "optional",
                "HttpPutResponseHopLimit": 1,
                "HttpEndpoint": "enabled"
            }
        }
    ],
    "OwnerId": "680235478471",
    "ReservationId": "r-07540918b65b09424"
}
```

I've got a new instance i-0529e7f9f72b02a53, but if I change the provisioned instance, In anyway, there is no easy way of knowing what has changed and there's no way of knowing what it is supposed to be.

Below is the same thing In Terraform, in code, stating how the instance should be:

```terraform
resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-7ad7c21e"
  subnet_id     = "subnet-05f8f3c120238ca8d"
  vpc_security_group_ids = [
    "sg-05749b21616ab0cdc",
  ]
}
```

Now If you modify the instance in any way - in this case by adding tags:

```cli
aws ec2 create-tags --resources i-0529e7f9f72b02a53 --tags Key=Stack,Value=production
```

You can check for configuration drift by using Terraform plan, (this is not possible with the cli) this command will show the difference between your original coded definition and current reality:

```cli
$terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

aws_instance.example: Refreshing state... [id=i-0529e7f9f72b02a53]

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_instance.example will be updated in-place
  ~ resource "aws_instance" "example" {
        ami                          = "ami-7ad7c21e"
        arn                          = "arn:aws:ec2:eu-west-2:680235478471:instance/i-0529e7f9f72b02a53"
        associate_public_ip_address  = false
        availability_zone            = "eu-west-2a"
        cpu_core_count               = 1
        cpu_threads_per_core         = 1
        disable_api_termination      = false
        ebs_optimized                = false
        get_password_data            = false
        hibernation                  = false
        id                           = "i-0529e7f9f72b02a53"
        instance_state               = "running"
        instance_type                = "t2.micro"
        ipv6_address_count           = 0
        ipv6_addresses               = []
        key_name                     = "basic"
        monitoring                   = false
        primary_network_interface_id = "eni-0898a0bee39c83400"
        private_dns                  = "ip-10-0-0-187.eu-west-2.compute.internal"
        private_ip                   = "10.0.0.187"
        security_groups              = []
        source_dest_check            = true
        subnet_id                    = "subnet-05f8f3c120238ca8d"
      ~ tags                         = {
          - "Stack" = "production" -> null
        }
        tenancy                      = "default"
        volume_tags                  = {}
        vpc_security_group_ids       = [
            "sg-05749b21616ab0cdc",
        ]

        credit_specification {
            cpu_credits = "standard"
        }

        metadata_options {
            http_endpoint               = "enabled"
            http_put_response_hop_limit = 1
            http_tokens                 = "optional"
        }

        root_block_device {
            delete_on_termination = true
            encrypted             = false
            iops                  = 200
            volume_id             = "vol-0e3a5e292da87bd32"
            volume_size           = 8
            volume_type           = "io1"
        }

        timeouts {}
    }

Plan: 0 to add, 1 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

Just the Tags are new.

This somehow detected the change in configuration.
You can eliminate the "drift" by executing Terraform Apply again.

## The Basics

In the previous section we use a few Terraform commands against a set of files.
If you run Terraform with the help command you will see there a quite a few options:

```cli
 terraform --help
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you're just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.

Common commands:
    apply              Builds or changes infrastructure
    console            Interactive console for Terraform interpolations
    destroy            Destroy Terraform-managed infrastructure
    env                Workspace management
    fmt                Rewrites config files to canonical format
    get                Download and install modules for the configuration
    graph              Create a visual graph of Terraform resources
    import             Import existing infrastructure into Terraform
    init               Initialize a Terraform working directory
    login              Obtain and save credentials for a remote host
    logout             Remove locally-stored credentials for a remote host
    output             Read an output from a state file
    plan               Generate and show an execution plan
    providers          Prints a tree of the providers used in the configuration
    refresh            Update local state file against real resources
    show               Inspect Terraform state or plan
    taint              Manually mark a resource for recreation
    untaint            Manually unmark a resource as tainted
    validate           Validates the Terraform files
    version            Prints the Terraform version
    workspace          Workspace management

All other commands:
    0.12upgrade        Rewrites pre-0.12 module source code for v0.12
    debug              Debug output management (experimental)
    force-unlock       Manually unlock the terraform state
    push               Obsolete command for Terraform Enterprise legacy (v1)
    state              Advanced state management
```

Of that list you use small basic sub-set frequently, you need to know, **init**, **apply**, **destroy** and **plan**.

It always starts with **init**, but that only needs to run initially and if you need a new module or change the state backend. The life-cycle is:

```cli
init->apply->destroy
```

## Idempotency

As you saw in the example Terraform doesn't create a new resource on every run. It differs from Tools like cloud formation or scripting in that is idempotent. When it fails it stops or fails it doesn't clean up automatically. You can fix your mistake and Terraform will only change what you changed and hopefully what failed in your last run.

Nearly all modern configuration management tools are Idempotent.

If you execute your AWS command:

```cli
aws ec2 run-instances --image-id ami-7ad7c21e --count 1 --instance-type t2.micro --key-name basic --region eu-west-2 --subnet-id subnet-05f8f3c120238ca8d
```

What would happen?

Yes, you'd get another new instances. This can get expensive if you're not paying close enough attention.

This doesn't happen with each invocation in Terraform, each invocation is matched with is resulting **Terrafrom.tfstate** or its state file which is used to maintain a record of activity.
This "statefile" is crucial to your use and understanding of how Terraform works.

To remove the instance via the cli id have execute a whole new cli command but id also have to find the instance_id.
With Terraform its just:

```cli
Terraform destroy
```

And the account will return to state it was before you created the instance, no orphaned objects ever remain.

## State

When you run an apply a state file **terraform.tfstate** is made, this records what infrastructure was made.

```json
{
  "version": 4,
  "terraform_version": "0.12.20",
  "serial": 1,
  "lineage": "48a6fad8-28ca-c946-5f42-c46721405781",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "aws_instance",
      "name": "example",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 1,
          "attributes": {
            "ami": "ami-7ad7c21e",
            "arn": "arn:aws:ec2:eu-west-2:680235478471:instance/i-0763a257a728d24eb",
            "associate_public_ip_address": false,
            "availability_zone": "eu-west-2a",
            "cpu_core_count": 1,
            "cpu_threads_per_core": 1,
            "credit_specification": [
              {
                "cpu_credits": "standard"
              }
            ],
            "disable_api_termination": false,
            "ebs_block_device": [],
            "ebs_optimized": false,
            "ephemeral_block_device": [],
            "get_password_data": false,
            "hibernation": false,
            "host_id": null,
            "iam_instance_profile": "",
            "id": "i-0763a257a728d24eb",
            "instance_initiated_shutdown_behavior": null,
            "instance_state": "running",
            "instance_type": "t2.micro",
            "ipv6_address_count": 0,
            "ipv6_addresses": [],
            "key_name": "",
            "metadata_options": [
              {
                "http_endpoint": "enabled",
                "http_put_response_hop_limit": 1,
                "http_tokens": "optional"
              }
            ],
            "monitoring": false,
            "network_interface": [],
            "network_interface_id": null,
            "password_data": "",
            "placement_group": "",
            "primary_network_interface_id": "eni-0d5fa924c7aebb3b8",
            "private_dns": "ip-10-0-0-89.eu-west-2.compute.internal",
            "private_ip": "10.0.0.89",
            "public_dns": "",
            "public_ip": "",
            "root_block_device": [
              {
                "delete_on_termination": true,
                "encrypted": false,
                "iops": 200,
                "kms_key_id": "",
                "volume_id": "vol-056aeda90e38c83d0",
                "volume_size": 8,
                "volume_type": "io1"
              }
            ],
            "security_groups": [],
            "source_dest_check": true,
            "subnet_id": "subnet-05f8f3c120238ca8d",
            "tags": null,
            "tenancy": "default",
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": {},
            "vpc_security_group_ids": [
              "sg-05749b21616ab0cdc"
            ]
          },
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDAsImRlbGV0ZSI6MTIwMDAwMDAwMDAwMCwidXBkYXRlIjo2MDAwMDAwMDAwMDB9LCJzY2hlbWFfdmVyc2lvbiI6IjEifQ=="
        }
      ]
    }
  ]
}

```

This file is left in your folder when you are using Local state. Local state is the most basic type and should only be used at the start.

It doesn't work when your collaborating or have an automatic process - CI. Corrupting it or losing it is also a major pain. You should always use remote state. 

### AWS S3

This is the Old way. Doesn't make so much sense if you're mutli-cloud/api. 

- Create an S3 Bucket.
- Manage the bucket yourself.
- IAM and Bucket permissions.
- Add reference terraform.tf.

```terraform
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
```

### Terraform cloud

This is the new way. Its managed by Hashicorp, so no maintenance overhead and at all and its easy for multi-cloud & multi-account. Its also a gateway to Terraform clouds other capabilities.

- Add reference **terraform.tf** to your template.

```terraform
terraform {
  backend "remote" {
    organization="Slalom"
    workspaces { name="basic-demo-instance"}
  }
}
```

Then set up the new state backend with:

```cli
$ terraform init

Initializing the backend...

Successfully configured the backend "remote"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.56.0...

Terraform has been successfully initialized!
```

Show workspace:
<https://app.terraform.io/app/Slalom/workspaces/basic-demo-instance/runs>

Open your cli and Terraform apply.

!!!note "Takeaways"
    - The destroy and apply command always give you a chance to review the changes before they happen.

## Exercise

1. Go through the Hashicorp Learn site for more basic information <https://learn.hashicorp.com/terraform>

## Questions

## Documentation

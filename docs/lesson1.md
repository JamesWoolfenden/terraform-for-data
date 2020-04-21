# Lesson 101 Introduction and Hello World

## Introduction to Terraform

What is Terraform

A declarative second generation Configuration Management tool designed to provision cloud based Infrastructure via Code.

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
Ive got a new instance i-0529e7f9f72b02a53, but if I change the provisioned instance, In anyway, there is no easy way of knowing what has changed and there's no way of knowing what it is supposed to be.

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

You can check for configuration drift by using Terraform plan, (this is not possible with the cli) this command will show the difference between your orignal coded definition and current reality:

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

### Idempotency

Configuration managament tools are generally Idempotent.

If you execute your AWS command:

```cli
aws ec2 run-instances --image-id ami-7ad7c21e --count 1 --instance-type t2.micro --key-name basic --region eu-west-2 --subnet-id subnet-05f8f3c120238ca8d
```

What would happen?

You'd get anopther new instances as the command is not Idempotent.

This doesn't happen with each invocation in Terraform, each invocation is matched with is resulting **Terrafrom.tfstate** or its state file which is used to maintain a record of activity.
This "statefile" is crucial to your use and understanding of how Terraform works.

To remove the instance via the cli id have exectute a whole new cli command but id also have to find the instance_id.
With Terraform its just:

```cli
Terraform destroy
```

And the account will return to state it was before you created the instance, no orphaned objects ever remain.

!!! note "Takeaways" 
    - The destroy and apply command always give you a chance to review the changes before they happen.

## Hello World

Ensure that you have Terraform and an editor (VScode) installed:

At your shell, make a **null resource** by creating a file called **null_resource.helloworld.tf**.

```bash
touch null_resource.helloworld.tf
```

A null resource doesn't do anything by itself and doesn't require any Cloud Provider Authentication.
Then add the block below to it.

```terraform
resource "null_resource" "hello_world" {
}
```

You have just created your first Terraform template, but as yet it does nothing.

The next step is to add a local executable Provisioner, to give the null resource some utility:

```terraform
resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    # This is a comment
    command = "echo 'hello world'"
  }
}
```

Fairly straighforward?

Time to try your work with **terraform init** at your shell.

```bash
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "null" (hashicorp/null) 2.1.2...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.null: version = "~> 2.1"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Terraform init is only needed on new templates and when you add modules or change module versions or providers.
You don't have to remember it all, Terraform will fail at apply.

Now that has been set up, you can try **terraform apply**, and when prompted, say yes.

```bash
$ terraform apply
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.hello_world will be created
  + resource "null_resource" "hello_world" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.hello_world: Creating...
null_resource.hello_world: Provisioning with 'local-exec'...
null_resource.hello_world (local-exec): Executing: ["cmd" "/C" "echo 'hello world'"]
null_resource.hello_world (local-exec): 'hello world'
null_resource.hello_world: Creation complete after 1s [id=5019739039794330655]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

You have made a Terraform template that does something!

Now check what files you have on your filesystem.

```bash
ls -al
total 1
drwxrwxrwx 1 jim jim 512 Feb 22 06:59 .
drwxrwxrwx 1 jim jim 512 Feb 22 06:54 ..
drwxrwxrwx 1 jim jim 512 Feb 22 06:56 .terraform
-rwxrwxrwx 1 jim jim 139 Feb 22 06:59 null.helloworld.tf
-rwxrwxrwx 1 jim jim 513 Feb 22 06:59 terraform.tfstate
```

**Terraform.tfstate** is your local state file

**.terraform** contains your providers and modules[if any].

### Refactor

We can be and should be more specify, state the exact Provider version required **provider.null.tf**

```terraform
provider "null" {
    version="2.1.2"
}
```

We specify versions so that we reproduce the same result.

Specify the TF core version by specifying Terraform version in **terraform.tf**

```terraform
terraform {
    required_version="0.12.20"
}
```

State files are linked to TF core version, all members of a team using TF need to use the same version. If one upgrades, all must upgrade, so add this to ensure that you mean to.

Re-test these changes with a new apply.

### Real world example

```terraform
resource "null_resource" "waiter" {
  depends_on = [aws_iam_instance_profile.ec2profile]

  provisioner "local-exec" {
    command = "sleep 15"
  }
}
```

This is basically a hack, pretty much any use of a null resources is up to something dubious. In this case AWS was being rubbish and reported that an object was made when it wasn't yet - _eventually consistent_ and so here we are with a sleep statement.
I rarely use Provisioners myself these days, they are bad style and a hangover from Terraforms beginnings.

!!! note "Takeaways"
    - Naming
    - Versions
    - Provisioners
    - Providers
    - Plan & apply

## Exercise

1. Change the required_version to "0.12.25" and Apply, what happens?

## Questions

1. When could specifying the Version still be insufficient for repeatability?
   - when the underlying API itself changes and is no longer backwardly compatible, this wont happen very quickly but it will happen.
     Its also is bound to the version of the Terraform tool you are using.

## Documentation

For more on null resource see the Hashicorp docs:
<https://www.terraform.io/docs/providers/null/resource.html>

# Lesson 101 Hello World

## my first template

To start, make a null resource by creating a file called **null_resource.helloworld.tf**.

A null resource doesn't do anything by itself.

```bash
touch null_resource.helloworld.tf
```

Then add the block below to it.

```terraform
resource "null_resource" "hello_world" {
}
```

You have created your first Terraform template, but as yet it does nothing.

Adding a local executable provisioner to give the null resource some utility:

```terraform
resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    # This is a comment
    command = "echo 'hello world'"
  }
}
```

Time to try your work with **terraform init**.

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

Specify the exact Provider version required **provider.null.tf**

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

!!! note "Takeaways" - Naming - Versions - Provisioners - Providers - Plan & apply

## Exercise

1. Change the required_version to "0.12.25" and Apply, what happens?

## Questions

## Documentation

For more on null resource see the Hashicorp docs:
<https://www.terraform.io/docs/providers/null/resource.html>

# Lesson 103 AWS RDS and SQLServer

## Modules

Like any modern languages, Terraform supports the use of libraries or in Terraform - Modules.
You can write you own, or re-use published modules. Hashicorp maintains a public Registry at <https://registry.terraform.io>.
You can save yourself and others a lot of time by using and publishing modules.

To create a MSSQL instance in RDS I write all resource myslef or I could re-use the existing module "jameswoolfenden/rds/aws" <https://registry.terraform.io/modules/JamesWoolfenden/rds/aws/0.1.4>

This is implemented in **module.sql.tf**

```terraform
module "rds-mssql" {
  source            = "jameswoolfenden/rds/aws"
  version           = "0.1.4"
  common_tags       = var.common_tags
  instance          = var.instance
  instance_password = "Password123"
  storage_encrypted = false
  subnet_group      = var.subnet_group
  subnet_ids        = var.subnet_ids
}
```

Add your **variables.tf**

```terraform
variable "instance" {
}

variable "subnet_group" {
}


variable "common_tags" {
}

variable "subnet_ids" {
}
```

And your values **sqlserver.auto.tfvars** you'll need to supply different subnets:

```HCL2
instance = {
  auto_minor_version_upgrade            = false
  allocated_storage                     = 20
  availability_zone                     = ""
  backup_retention_period               = 7
  backup_window                         = "23:01-23:31"
  copy_tags_to_snapshot                 = true
  create_db_parameter_group             = false
  deletion_protection                   = false
  engine                                = "sqlserver-ex"
  engine_version                        = "14.00.3223.3.v1"
  iam_database_authentication_enabled   = false
  identifier                            = "demodb"
  iops                                  = 0
  instance_class                        = "db.t2.micro"
  license_model                         = "license-included"
  monitoring_interval                   = 0
  maintenance_window                    = "tue:22:19-tue:22:49"
  monitoring_role_arn                   = ""
  max_allocated_storage                 = "1000"
  multi_az                              = false
  name                                  = ""
  option_group_name                     = "default:sqlserver-ex-14-00"
  parameter_group_name                  = "default.sqlserver-ex-14.0"
  password                              = "YourPwdShouldBeLongAndSecure!"
  performance_insights_enabled          = true
  performance_insights_retention_period = "7"
  port                                  = "1433"
  security_group_names                  = null
  skip_final_snapshot                   = true
  snapshot_identifier                   = ""
  storage_type                          = ""
  timezone                              = "Central Standard Time"
  username                              = "admin"
}

common_tags = {
  "createdby" = "Terrraform"
}

subnet_group = [{
  name        = "group-1"
  name_prefix = null
  description = "sql dbs"
}]

subnet_ids = ["subnet-f60eff81", "subnet-11438974", "subnet-ebd9cead"]
```

Now when you apply, you will (eventually SQLServer provisioning is slow) create a MSSQL server instance.

!!!note "Takeaways"
    - reuse

## Exercises

1. Create a module of your own.
2. Create an instance using the module and connect to the SQL instance.
3. Automatically obtain the SQL endpoint.

## Questions

## Documentation

For more on null resource see the Hashicorp docs:
<https://www.terraform.io/docs/providers/null/resource.html>

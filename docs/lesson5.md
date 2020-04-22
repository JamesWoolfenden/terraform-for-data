# Lesson 104 Terraforming Snowflake

## Install Custom Snowflake provider

From <https://github.com/chanzuckerberg/terraform-provider-snowflake> download your platforms latest provider <https://github.com/chanzuckerberg/terraform-provider-snowflake/releases>:

Or find the example archive **examples\lesson04\terraform-provider-snowflake_0.11.0_linux_amd64.tar.gz**

Expand the archive and add it to your Terraform plugins:

```bash
tar -xvf terraform-provider-snowflake_0.11.0_linux_amd64.tar.gz
mv terraform-provider-snowflake_v0.11.0 $HOME/.terraform.d/plugins/linux_amd64/
```

ToSet-up Authentication with Snowflake, you'll need to add your Snowflake credentials as environmental variables:

```bash
export SNOWFLAKE_USER='yourusername'
export SNOWFLAKE_PASSWORD='yourpassword'
```

and then create _provider.snowflake.tf_ to managed the Snowflake provider in Terraform.

```terraform
provider "snowflake" {
  account = "ba82113"
  region  = "eu-west-1"
  version = "0.11"
}
```

Adding in your own vales for **account and region**

You can then check authentication using Terraform **init** and **plan**.

Now that Authectication is validated, then next step is to try and create some Snowflake objects.

Starting with Schemas - **snowflake_schmea.schema.tf**.

```terraform
resource "snowflake_schema" "schema" {
  for_each = var.schemas
  name     = each.key
  database = each.value.database
  comment  = each.value.comment
}
```

This template needs to have the variable **schema** defined, create **variables.tf**

```terraform
variable "schemas" {
}
```

And set the values for your schemas with **snowflake.auto.tfvars**

```json
schemas = {
    "RAW" = {
      database = "DEMO_DB"
      comment = "contains raw data from our source systems"
    }
    "ANALYTICS" = {
      database = "DEMO_DB"
      comment = "contains tables and views accessible to analysts and reporting"
    }
  }
```

This should now create 2 schemas, RAW and ANALYTICS (assuming you already have a DEMO_DB).

Test as before with Terraform init and plan

```bash
 $ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # snowflake_schema.schema["ANALYTICS"] will be created
  + resource "snowflake_schema" "schema" {
      + comment             = "contains tables and views accessible to analysts and reporting"
      + data_retention_days = 1
      + database            = "DEMO_DB"
      + id                  = (known after apply)
      + is_managed          = false
      + is_transient        = false
      + name                = "ANALYTICS"
    }

  # snowflake_schema.schema["RAW"] will be created
  + resource "snowflake_schema" "schema" {
      + comment             = "contains raw data from our source systems"
      + data_retention_days = 1
      + database            = "DEMO_DB"
      + id                  = (known after apply)
      + is_managed          = false
      + is_transient        = false
      + name                = "RAW"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------
```

Invoke the changes with **Terraform apply**, selecting yes:

```bash
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

snowflake_schema.schema["ANALYTICS"]: Creating...
snowflake_schema.schema["RAW"]: Creating...
snowflake_schema.schema["ANALYTICS"]: Creation complete after 1s [id=DEMO_DB|ANALYTICS]
snowflake_schema.schema["RAW"]: Creation complete after 1s [id=DEMO_DB|RAW]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Terraform is stating that the Schemas have been created, you can verify the changes in the Snowflake UI, or via SnowSQL with:

```sql
describe database DEMO_DB;

created_on	name	kind
2020-04-21 02:33:30.727 -0700	ANALYTICS	SCHEMA
2020-04-21 02:35:19.987 -0700	INFORMATION_SCHEMA	SCHEMA
2020-04-17 02:02:42.057 -0700	PUBLIC	SCHEMA
2020-04-21 02:33:30.736 -0700	RAW	SCHEMA
```

So thats Terraform creating Snowflake resources via IaC.

You can then clean up remove these schemas with Terraform destroy:

```bash
 $ terraform  destroy
snowflake_schema.schema["RAW"]: Refreshing state... [id=DEMO_DB|RAW]
snowflake_schema.schema["ANALYTICS"]: Refreshing state... [id=DEMO_DB|ANALYTICS]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # snowflake_schema.schema["ANALYTICS"] will be destroyed
  - resource "snowflake_schema" "schema" {
      - comment             = "contains tables and views accessible to analysts and reporting" -> null
      - data_retention_days = 1 -> null
      - database            = "DEMO_DB" -> null
      - id                  = "DEMO_DB|ANALYTICS" -> null
      - is_managed          = false -> null
      - is_transient        = false -> null
      - name                = "ANALYTICS" -> null
    }

  # snowflake_schema.schema["RAW"] will be destroyed
  - resource "snowflake_schema" "schema" {
      - comment             = "contains raw data from our source systems" -> null
      - data_retention_days = 1 -> null
      - database            = "DEMO_DB" -> null
      - id                  = "DEMO_DB|RAW" -> null
      - is_managed          = false -> null
      - is_transient        = false -> null
      - name                = "RAW" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

snowflake_schema.schema["RAW"]: Destroying... [id=DEMO_DB|RAW]
snowflake_schema.schema["ANALYTICS"]: Destroying... [id=DEMO_DB|ANALYTICS]
snowflake_schema.schema["ANALYTICS"]: Destruction complete after 1s
snowflake_schema.schema["RAW"]: Destruction complete after 1s

Destroy complete! Resources: 2 destroyed.
```

Which again can be checked with describing the Database:

```sql
created_on	name	kind
2020-04-21 02:38:39.248 -0700	INFORMATION_SCHEMA	SCHEMA
2020-04-17 02:02:42.057 -0700	PUBLIC	SCHEMA
```

!!!note "Takeaways" - blah
    - Can create Snowflake db objects via Terraform.
    - Clean of DB objects by default.

## Exercise

1. Create Snowflake users via Terraform.

## Questions

1. Is this any better than using standard SQL tooling?

## Documentation

For more on null resource see the Hashicorp docs:
<https://www.terraform.io/docs/providers/null/resource.html>

<https://github.com/chanzuckerberg/terraform-provider-snowflake>
<https://adam.boscarino.me/posts/terraform-snowflake/>

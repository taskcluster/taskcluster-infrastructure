# taskcluster-terraform

This is a work in progress to define the Taskcluster team's AWS configuration in Terraform.

# Running

The user must specify an `aws_access_key`, and `aws_secret_key`.

Variables should be provided either on the command line, e.g.

```
terraform apply -var region=us-west-1 -var 'aws_access_key=XXXXXXXXXXX'
```

or by creating a `terraform.tfvars` file, e.g.:

```
aws_access_key="XXXXXXXXXXXX"
```

It's best to not write the `aws_secret_key` to disk.  Instead, allow Terraform
to prompt for it and paste it.

## Operation

Run `terraform plan` to see what would happen, and `terraform apply` to apply it.

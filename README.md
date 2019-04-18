# Infrastructure Management for taskcluster

## Prerequisites

You'll need the following software to get started:
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [kops](https://github.com/kubernetes/kops)
* [terraform](https://www.terraform.io/)

## Setup

To set up your local working environment run:
 * `. <(pass terraform/secrets.sh)`
 * `. ./import-docker-worker-secrets.sh`
 * `terraform init`

## Usage
After performing the setup steps above run:
 * `terraform validate|plan|apply`

The `validate` step does not make any changes to the actual deployment.  The
`plan` operation does not make changes but does acquire the state lock in order
to run.  The `apply` step will acquire the state lock, but will only make
changes if necessary.

Any secrets added should be documented as variables in `secrets.tf` and added
to the `terraform/secrets.sh` script in password-store.

## Deploying a new version of a static service

In `static-services.tf` each service has both a `image_tag` and `image_hash`
field that can be updated to deploy a new version of the service. The
`image_hash` is the `sha256 Digest` of an image. Once you update this field and
`terraform apply`, the ec2 instance will be replaced by a new one (this does
involve downtime!) and the eip will be hooked into the new instance.

## Troubleshooting

### Locked State

The full error message looks like (or is a variant of):

`Error: Error locking state: Error acquiring the state lock: storage: service returned error: StatusCode=409, ErrorCode=LeaseAlreadyPresent, ErrorMessage=There is already a lease present.`

You will need to manually break the terraform lease to perform *any* further
actions. The lease is attached to a terraform state blob that lives in Azure.

To break the lease:
* open the Azure portal
* navigate to Resources
* open tcterraformstate->Blobs->tfstate
* click on the three-dots menu for the state-test2.tf blob, and select "Break lease"

See also https://github.com/hashicorp/terraform/issues/17046#issuecomment-359597285

### Packet.net

#### General

We build each instance from scratch in packet.net, rather than tweaking an
existing image, although we do expect to move to images soon. The from-scratch
process means that there are many steps that can timeout or fail, usually due
to network issues when installing large collections of Ubuntu packages.

If the process fails, it is safest to perform a `terraform destroy` followed
by another `terraform apply` attempt. I have had little success in simply
re-`apply`ing because usually something has failed to install properly and
the instance state will be unknown.

```
# e.g. If machine-23 fails to instantiate...
terraform destroy -target packet_device.docker_worker[23] -auto-approve
terraform apply -target packet_device.docker_worker[23] -auto-approve
```

Depending on when in the `apply` process the error occurs, running `apply`
repeatedly can sometimes spawn multiple instances with the same name. You
can check for this in the Servers list of the packet.net UI, where you can
also delete the offending instances.


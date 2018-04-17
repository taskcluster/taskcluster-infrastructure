Infrastructure Management for taskcluster
=========================================

To run this do:
 * `. <(pass terraform/secrets.sh)`
 * Set AWS environment variables
 * Use `terraform validate|plan|apply`

Any secrets added should be documented as variables in `secrets.tf` and added
to the `terraform/secrets.sh` script in password-store.

Kubernetes is managed with [kops](https://github.com/kubernetes/kops).

Locked State
------------

If the state becomes locked because a process fails:

 * Open the Azure portal
 * Navigate to the tcterraformstate account
 * Navigate to the tfstate container
 * Find the blob in the "Leased" state
 * Click the "..." menu and select "Break Lease".

Deploying a new version of a static service
-------------------------------------------

In `static-services.tf` each service has both a `image_tag` and `image_hash`
field that can be updated to deploy a new version of the service. The
`image_hash` is the `sha256 Digest` of an image. Once you update this field and
`terraform apply`, the ec2 instance will be replaced by a new one (this does
involve downtime!) and the eip will be hooked into the new instance.

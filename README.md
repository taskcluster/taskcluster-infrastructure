Infrastructure Management for taskcluster
=========================================

To run this do:
 * `eval "$(pass terraform/secrets.sh)"`
 * Set AWS environment variables
 * Use `terraform validate|plan|apply`

Any secrets added should be documented as variables in `secrets.tf` and added
to the `terraform/secrets.sh` script in password-store.

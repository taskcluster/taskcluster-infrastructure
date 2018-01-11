Infrastructure Management for taskcluster
=========================================

To run this do:
 * `eval "$(pass terraform/secrets.sh)"`
 * Set AWS environment variables
 * Use `terraform validate|plan|apply`

Any secrets added should be documented as variables in `secrets.tf` and added
to the `terraform/secrets.sh` script in password-store.

Locked State
------------

If the state becomes locked because a process fails:

 * Open the Azure portal
 * Navigate to the tcterraformstate account
 * Navigate to the tfstate container
 * Find the blob in the "Leased" state
 * Click the "..." menu and select "Break Lease".

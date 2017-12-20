Infrastructure Management for taskcluster
=========================================

Assumes environment variables:
 * `ARM_ACCESS_KEY` azure access credentials for storage account `tcterraformstate`.
 * `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`, for our aws account.

To run this do:
 * `eval $(pass azure/tcterraformstate.sh)`
 * Set AWS environment variables
 * Use `terraform validate|plan|apply`

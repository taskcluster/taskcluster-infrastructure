#!/bin/bash -e

# This script reads docker-worker store in passwordstore and writes
# up deploy.json.
#
# Use: deploy/bin/import-docker-worker-secrets
#
# Notice you must have taskcluster passwordstore cloned and configured.
# See ssh://gitolite3@git-internal.mozilla.org/taskcluster/secrets.git
# for details.

DEPLOYMENT=taskcluster-net
base_dir=/tmp/docker-worker-secrets/${DEPLOYMENT}
rm -rf $base_dir
mkdir -p $base_dir
chmod 0700 $base_dir

read -s -p "Enter your gpg passphrase, or enter for none (e.g., Yubikey): " passphrase
if [ -n "$passphrase" ]; then
    export PASSWORD_STORE_GPG_OPTS="--passphrase=$passphrase"
else
    echo
    echo '(no passphrase set)'
fi

# read the secrets into a shell array
declare -A SECRETS
set-secret() {
    echo "Setting secret $1" >&2
	SECRETS[$1]="${2}"
}

source <(pass show docker-worker/${DEPLOYMENT}) || exit 1

get-secret() {
	if [ ${SECRETS[$1]+_} ]; then
		echo "${SECRETS[$1]}"
	else
        echo "Secret $1 not defined" >&2
        exit 1
    fi
}

export TF_VAR_docker_worker_private_key=$(get-secret shared-env-var-key)

export TF_VAR_docker_worker_ssl_certificate=$(get-secret livelog-tls-cert)

export TF_VAR_docker_worker_cert_key=$(get-secret livelog-tls-key)


#!/bin/bash
echo $0: creating public and private key files

# Create the .ssh directory
mkdir -p ${HOME}/.ssh
chmod 700 ${HOME}/.ssh

# Create the public and private key files from the environment variables.
echo "${DEPLOYMENT_PUBLIC_KEY}" > ${HOME}/.ssh/id_rsa.pub
chmod 644 ${HOME}/.ssh/id_rsa.pub

# Note use of double quotes, required to preserve newlines
echo "${DEPLOYMENT_PRIVATE_KEY}" > ${HOME}/.ssh/id_rsa
chmod 600 ${HOME}/.ssh/id_rsa

# Preload the known_hosts file  (see "version 2" below)

# Start the SSH tunnel if not already running
SSH_CMD="ssh -f -i ${HOME}/.ssh/id_rsa -N -L 2222:www01.agileoperations.co.uk:22 ec2-user@nat.agileoperations.co.uk"

PID=`pgrep -f "${SSH_CMD}"`
if [ $PID ] ; then
    echo $0: tunnel already running on ${PID}
else
    echo $0 launching tunnel
    $SSH_CMD
fi

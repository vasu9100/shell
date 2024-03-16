#!/bin/bash

# Specify the filename for the SSH key
SSH_KEY_FILE="$HOME/.ssh/id_rsa"

# Check if the SSH key file exists
if [ -f "$SSH_KEY_FILE" ]; then
    echo "SSH key already exists: $SSH_KEY_FILE"
else
    # Generate SSH key pair
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_FILE"
    echo "SSH key generated: $SSH_KEY_FILE"
fi

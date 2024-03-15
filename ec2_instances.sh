#!/bin/bash

AMI_ID="ami-0f3c7d07486cad139"
SG_ID="sg-0eab7d3878626d44d"
INSTANCE_TYPE="t2.micro"
BIG_INSTANCES="t3.small"
INSTANCE_NAMES=("mysql" "web" "shipping" "payment" "redis" "catalogue" "rabbit" "user" "cart" "dispatch" "mongo")

for name in "${INSTANCE_NAMES[@]}"
do
    if [[ $name == "mysql" || $name == "redis" || $name == "mongo" ]]; then
        echo "Launching $name instance with $BIG_INSTANCES"
        # Add your instance launching command here using $BIG_INSTANCES
    else
        echo "Launching $name instance with $INSTANCE_TYPE"
        # Add your instance launching command here using $INSTANCE_TYPE
    fi
done

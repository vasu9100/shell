#!/bin/bash

AMI_ID="ami-0f3c7d07486cad139"
SG_ID="sg-0eab7d3878626d44d"
SMALL_INSTANCE_TYPE="t2.micro"
BIG_INSTANCES="t3.small"
INSTANCE_NAMES=("mysql" "web" "shipping" "payment" "redis" "catalogue" "rabbit" "user" "cart" "dispatch" "mongo")

for name in "${INSTANCE_NAMES[@]}"
do
    if [[ $name == "mysql" || $name == "redis" || $name == "mongo" ]]; then
        echo "Launching $name instance with $BIG_INSTANCES"
        INSTANCE_TYPE=$BIG_INSTANCES

    else
        echo "Launching $name instance with $SMALL_INSTANCE_TYPE"
        INSTANCE_TYPE=$SMALL_INSTANCE_TYPE
    fi
    result=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --security-group-ids "$SG_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$name}]" \
    --query 'Instances[0].PrivateIpAddress')
    # Add your instance launching command here using $BIG_INSTANCES    
done

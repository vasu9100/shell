#!/bin/bash

AMI_ID="ami-0f3c7d07486cad139"
SG_ID="sg-0eab7d3878626d44d"
SMALL_INSTANCE_TYPE="t2.micro"
BIG_INSTANCES="t3.small"
INSTANCE_NAMES=("mysql" "web" "shipping" "payment" "redis" "catalogue" "rabbit" "user" "cart" "dispatch" "mongo")
zone_id="Z08382393NBPVIFQUJM1I"

for name in "${INSTANCE_NAMES[@]}"
do
    if [[ $name == "mysql" || $name == "redis" || $name == "mongo" ]]; then
        echo "Launching $name instance with $BIG_INSTANCES"
        INSTANCE_TYPE=$BIG_INSTANCES
    else
        echo "Launching $name instance with $SMALL_INSTANCE_TYPE"
        INSTANCE_TYPE=$SMALL_INSTANCE_TYPE
    fi
    
    # Launch instance with appropriate tags
    result=$(aws ec2 run-instances \
            --image-id "$AMI_ID" \
            --instance-type "$INSTANCE_TYPE" \
            --security-group-ids "$SG_ID" \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$name}]" \
            --query 'Instances[0].PrivateIpAddress'\
            --output text)
    
    # Check if the aws command executed successfully
    if [ $? -eq 0 ]; then
        echo "Instance $name launched with private IP: $result"
    else
        echo "Failed to launch instance $name"
        # Handle the error as needed
    fi

    aws route53 change-resource-record-sets \
    --hosted-zone-id "$zone_id" \
    --change-batch "{
        \"Changes\": [
            {
                \"Action\": \"UPSERT\",
                \"ResourceRecordSet\": {
                    \"Name\": \"$name.gonepudirobot.online\",
                    \"Type\": \"A\",
                    \"TTL\": 1,
                    \"ResourceRecords\": [
                        {
                            \"Value\": \"$result\"
                        }
                    ]
                }
            }
        ]
    }"



    if [ $? -eq 0 ]; then
        echo "Instance route created with $name.gonepudirobot.online private IP: $result"
    else
        echo "Failed to launch instance $name"
        # Handle the error as needed
    fi

    echo "IPS list:: $result"

done

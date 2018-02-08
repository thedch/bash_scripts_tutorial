#!/bin/bash
# Author: daniel
# February 06 2018

if [ "$#" -ne 1 ]; then
        echo "$0: [ERROR] Please provide t2, p2, or car as an argument."
        exit 3
fi

if [ $1 == 'stop' ]; then
    aws ec2 stop-instances --instance-ids i-016940554988ae126
    aws ec2 stop-instances --instance-ids i-088218b334cf97c8d
    aws ec2 stop-instances --instance-ids i-0df581e7c85a4bc89
    exit 0
fi

if [ $1 == 'p2' ]; then
    instanceId='i-016940554988ae126'
fi

if [ $1 == 't2' ]; then
    instanceId='i-088218b334cf97c8d'
fi

if [ $1 == 'car' ]; then
    instanceId='i-0df581e7c85a4bc89'
fi

# Start the instance
echo 'Booting up the instance...'
aws ec2 start-instances --instance-ids $instanceId && \
aws ec2 wait instance-running --instance-ids $instanceId && \
instanceIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$instanceId" --query "Reservations[0].Instances[0].PublicIpAddress"`

echo 'Waiting a few seconds to ensure full startup...'
sleep 10 # Sleep while the instance boots

# # SSH into the instance
ssh -L localhost:8888:localhost:8888 -i ~/.ssh/aws-key-fast-ai.pem ubuntu@$instanceIp
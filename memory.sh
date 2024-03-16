#!/bin/bash
MEMORY_CUTOFF=30
MEMORY_USAGE_DEVTMPF=$(df -h | grep '^(devtmpf)' | awk '{print $5}' | sed 's/%//')
MEMORY_USAGE_DEV=$(df -h | grep '^(/dev)' | awk '{print $5}' | sed 's/%//')

if [ $MEMORY_USAGE_DEVTMPF -ge $MEMORY_CUTOFF ]
then
    echo "Memory Exceeding 'devtmpf' :: $MEMORY_USAGE"
fi 

if [ $MEMORY_USAGE_DEV -ge $MEMORY_CUTOFF ]
then
    echo "Memory Exceeding '/dev':: $MEMORY_USAGE"
fi 
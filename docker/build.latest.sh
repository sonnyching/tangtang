#!/bin/bash

unset KUBECONFIG

cd .. && docker build -f docker/Dockerfile.latest \
             -t sonnyching/tangtang .

docker tag sonnyching/tangtang sonnyching/tangtang:$(date +%y%m%d)

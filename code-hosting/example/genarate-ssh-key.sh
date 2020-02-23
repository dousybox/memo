#!/bin/bash
hostName=$(hostname)
read -p "enter the platform name: " platformName
ssh-keygen -t rsa -b 4096 -C "${hostName}@${platformName}" -f ~/.ssh/${platformName}_rsa
cat ~/.ssh/${platformName}_rsa.pub | clip
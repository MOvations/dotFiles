#!/bin/bash

echo "checkup for permissions on ssh folder"

chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/*
chmod 644 -f ~/.ssh/*.pub ~/.ssh/authorized_keys ~/.ssh/known_hosts
# sudo chown pi:pi ~/.ssh/authorized_keys

#!/usr/bin/env bash

multipass launch --cpus 4 --mem 4G --disk 30G --cloud-init ./cloud-config.yml --name docker

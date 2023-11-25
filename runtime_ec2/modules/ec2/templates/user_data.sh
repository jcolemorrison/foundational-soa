#!/usr/bin/env bash
# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


cd /home/ubuntu
echo "${setup}" | base64 -d | zcat >setup.sh
chown ubuntu:ubuntu setup.sh
chmod +x setup.sh
./setup.sh
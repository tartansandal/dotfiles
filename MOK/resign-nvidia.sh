#!/bin/bash

set -e

sudo --validate
sudo ./resign-module.sh nvidia
sudo modprobe nvidia

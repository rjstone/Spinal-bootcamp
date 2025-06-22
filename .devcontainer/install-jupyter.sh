#!/bin/sh

apt update
# This seems to be as small as I can get it.
apt install -y jupyter-console jupyter-client python3-ipykernel

jupyter kernelspec list --debug
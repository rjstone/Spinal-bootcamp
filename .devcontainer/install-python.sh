#!/bin/sh

apt-get update
apt-get -y install python3 python3-ipykernel

export UV_INSTALL_DIR="/usr/local/bin"
curl -LsSf https://astral.sh/uv/install.sh | /bin/bash

uv self update
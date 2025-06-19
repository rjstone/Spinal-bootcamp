# for format details, see https://docs.docker.com/engine/reference/builder/

# Base Image
ARG VARIANT="3.12-bullseye"
# FROM mcr.microsoft.com/devcontainers/base:ubuntu:${VARIANT}
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}
# FROM mcr.microsoft.com/devcontainers/anaconda

# Almond Jupyter Kernel
ARG VARIANT="latest"
FROM almondsh/almond:${VARIANT}

# SpinalHDL
ARG VARIANT="master"
FROM ghcr.io/spinalhdl/docker:${VARIANT}

LABEL author="rjstone@github" maintainer="rjstone@github" version="0.0.1"

# read and create user
ARG USER="vscode"

# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# change user
USER ${USER}

WORKDIR /home/${USER}/

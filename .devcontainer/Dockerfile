# for format details, see https://docs.docker.com/engine/reference/builder/

ARG BASE_VARIANT="2-jammy"

FROM mcr.microsoft.com/devcontainers/base:${BASE_VARIANT}

ARG USERNAME "vscode"
RUN <<EOF
export DEBIAN_FRONTEND=noninteractive
apt-get update
# optional: restore 'man'
yes | unminimize 2>&1
apt-get install -y --no-install-recommends \
  sudo fish xonsh unzip zip curl wget openjdk-18-jdk
apt-get update
apt-get upgrade -y
# optional: provide sudo access
echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME
# These may not be needed but they're here "just in case".
apt-get autoremove -y
apt-get clean -y
apt-get purge -y
rm -rf /tmp/scripts
apt-get update
EOF

ENV SHELL=/bin/bash DOCKER_BUILDKIT=1

ARG USERNAME
COPY load-spinal.sc /home/${USERNAME}/
# change user, not root anymore.

ARG USERNAME
WORKDIR /home/${USERNAME}/

ARG USERNAME
USER ${USERNAME}

RUN <<EOF
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux-mostly-static.gz" | gzip -d > /tmp/cs
chmod +x /tmp/cs
/tmp/cs setup -v -y
rm -rf /tmp/cs
cd $HOME
. ./.profile
coursier install almond mill
pipx install --force --include-deps notebook jupyter-core jupyter-client jupyter-server
ipython kernel install --user
almond --install -f
jupyter kernelspec list > kernelspec.txt
jupyter --paths
jupyter --paths > jupyter-paths.txt
. ./.profile
git clone --depth 1 https://github.com/SpinalHDL/SpinalTemplateSbt.git SpinalTemplateSbt
cd SpinalTemplateSbt
rm -rf .git
EOF

LABEL description="VSCode/VSCodium dev container for Jupyter + Scala + SpinalHDL" \
      author="rjstoneus@gmail.com" \
      maintainer="rjstoneus@gmail.com" \
      version="0.0.4"


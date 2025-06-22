#!/bin/bash

# These should be provided in the env by the Dockerfile, but they can be
# overridden here if needed.
#export COURSIER_INSTALL_DIR=/usr/local/bin
#SCALA_VERSION=2.13.1
#ALMOND_VERSION=0.14.1

export COURSIER_BIN_DIR=$COURSIER_INSTALL_DIR

# List of utilities to install as standalones.
scala_tools=("ammonite" "csbt" "dotty-repl"
            "mill" "sbt"
            "scala" "scalac" "scala-cli" "scalafmt"
            "scala3"
            "almond" )


coursier_install_standalone() {
  local descriptor="$1"
  local output="$COURSIER_INSTALL_DIR/$descriptor"
  echo "Attempting to build standalone:$descriptor..."
  cs bootstrap -v $descriptor \
    --standalone --sources --default=true --scala-version=${SCALA_VERSION} \
    -f -o $output \
    && echo "Built and installed standalone: $output" \
    || echo "Standalone build failed for: $output"
}

cd /tmp
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux-mostly-static.gz" | gzip -d > /tmp/cs
chmod +x /tmp/cs

/tmp/cs bootstrap -v cs \
    --standalone --sources --default=true --scala-version=${SCALA_VERSION} \
    -f -o $COURSIER_INSTALL_DIR/cs
rm -rf /tmp/cs
ln -sf $COURSIER_INSTALL_DIR/cs $COURSIER_INSTALL_DIR/coursier

# Install all utilities in the list
# Iterate over each string in the array and call the function
for descriptor in "${scala_tools[@]}"; do
    coursier_install_standalone "$descriptor"
done

# Regular Scala almond kernel install
almond --install --global -f --id scala${SCALA_VERSION} \
      --display-name "Scala (${SCALA_VERSION})" \
      --jupyter-path /usr/share/jupyter/kernels/

# cleanup
rm -rf /tmp/cs /tmp/almond

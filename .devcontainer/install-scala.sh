#!/bin/bash

# These should be provided in the env by the Dockerfile, but they can be
# overridden here if needed.
#export COURSIER_INSTALL_DIR=/usr/local/bin
#SCALA_VERSION=2.13.1
#ALMOND_VERSION=0.14.1

export COURSIER_BIN_DIR=$COURSIER_INSTALL_DIR

# List of utilities to install as standalones.
scala_tools=("ammonite" "csbt" "dotty-repl"
            "mill"
            "sbt" "sbtn"
            "scala" "scalac" "scala-cli" "scalafmt"
            "scala3" )

# This is to create a special SpinalHDL almond kernel
PREDEF_CODE='interp.load.module(os.Path("/usr/local/lib/load-spinal.sc"))'

courser_install_standalone() {
  local descriptor="$1"
  local output="$COURSIER_INSTALL_DIR/$descriptor"
  echo "Attempting to build standalone:$descriptor..."
  cs bootstrap -v -P $descriptor \
    --standalone --sources --default=true --scala-version=${SCALA_VERSION} \
    -f -o $output \
    && echo "Built and installed standalone: $output" \
    || echo "Standalone build failed for: $output"
}

cd /tmp
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux-mostly-static.gz" | gzip -d > /tmp/cs
chmod +x /tmp/cs

/tmp/cs bootstrap -v -P cs \
    --standalone --sources --default=true --scala-version=${SCALA_VERSION} \
    -f -o $COURSIER_INSTALL_DIR/cs
rm -rf /tmp/cs
ln -s $COURSIER_INSTALL_DIR/cs $COURSIER_INSTALL_DIR/coursier

# Regular Scala almond kernel install
cs launch -v -P --use-bootstrap \
    --sources --default=true --scala-version=${SCALA_VERSION} \
    almond:${ALMOND_VERSION}  \
    -- --install --global -f --id scala${SCALA_VERSION} \
      --display-name "Scala (${SCALA_VERSION})" \
      --jupyter-path /usr/share/jupyter/kernels/

# SpinalHDL almond kernel install
cs launch -v -P --use-bootstrap \
    --sources --default=true --scala-version=${SCALA_VERSION} \
    almond:${ALMOND_VERSION}  \
    -- --install --global -f --id spinalhdl \
      --display-name "SpinalHDL" --predef-code "${PREDEF_CODE}" \
      --banner "SpinalHDL Loaded" \
      --jupyter-path /usr/share/jupyter/kernels/

# Iterate over each string in the array and call the function
for descriptor in "${scala_tools[@]}"; do
    courser_install_standalone "$descriptor"
done

# cleanup
rm -rf /tmp/cs /tmp/almond

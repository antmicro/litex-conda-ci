#!/bin/bash

source $TRAVIS_BUILD_DIR/.travis/common.sh
set -e

# Getting the conda environment
start_section "environment.conda" "Setting up basic ${YELLOW}conda environment${NC}"

branch=${TRAVIS_PULL_REQUEST_BRANCH:-$TRAVIS_BRANCH}
mkdir -p $BASE_PATH
./.travis/conda-get.sh $CONDA_PATH
hash -r

# Install the conda-build-prepare
python -m pip install git+https://github.com/antmicro/conda-build-prepare@861fc81feb1a8cdbbe52c899628805020f025e40#egg=conda-build-prepare

# Prepare the recipe and create workdir/conda-env to be activated
python -m conda_build_prepare --dir workdir $PACKAGE

# Freshly created conda environment will be activated by the common.sh
source $TRAVIS_BUILD_DIR/.travis/common.sh

end_section "environment.conda"

$SPACER

# Output some useful info
start_section "info.conda.env" "Info on ${YELLOW}conda environment${NC}"
conda info
end_section "info.conda.env"

start_section "info.conda.config" "Info on ${YELLOW}conda config${NC}"
conda config --show
echo
conda config --show-sources
end_section "info.conda.config"

start_section "info.conda.package" "Info on ${YELLOW}conda package${NC}"
# This is the fully rendered metadata file
cat workdir/recipe/meta.yaml
end_section "info.conda.package"

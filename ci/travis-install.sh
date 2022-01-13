#!/usr/bin/env bash

if [[ "${BUILDMODE}" == "ASTROPY" ]]; then
    echo "Set Conda Environment"
    if [[ -z "${MINICONDA_VERSION}" ]]; then
        MINICONDA_VERSION=4.7.10
    fi
    if [[ $(uname) == "Darwin" ]]; then
        command curl -sSL https://rvm.io/mpapis.asc | gpg --import -;
        rvm get stable
        if [[ -z "${MACOSX_DEPLOYMENT_TARGET}" ]]; then
            export MACOSX_DEPLOYMENT_TARGET=10.9
        elif [[ "${MACOSX_DEPLOYMENT_TARGET}" == "clang_default" ]]; then
            export MACOSX_DEPLOYMENT_TARGET=""
        fi
        wget https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-MacOSX-x86_64.sh -O miniconda.sh
        mkdir $HOME/.conda
        bash miniconda.sh -b -p $HOME/miniconda
        $HOME/miniconda/bin/conda init bash
        source ~/.bash_profile
        conda activate base
        source "$( dirname "${BASH_SOURCE[0]}" )"/setup_dependencies_common.sh
    else
       wget https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh --progress=dot:mega
       mkdir $HOME/.conda
       bash miniconda.sh -b -p $HOME/miniconda
       $HOME/miniconda/bin/conda init bash
       source ~/.bash_profile
       conda activate base
       source "$( dirname "${BASH_SOURCE[0]}" )"/setup_dependencies_common.sh
       if [[ $SETUP_XVFB == True ]]; then
           export DISPLAY=:99.0
           /sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -screen 0 1920x1200x24 -ac +extension GLX +render -noreset
       fi
    fi
    echo "Done sourcing conda environment"
elif [[ "${BUILDMODE}" == "CIBUILDWHEEL" ]]; then
  export PIP=pip
  if [[ $(uname) == "Darwin" ]]; then
    export PIP=pip
  fi
  echo "Should install"
  $PIP install cibuildwheel
fi

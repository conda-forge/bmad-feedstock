#!/usr/bin/env bash

if [ -z "$ACC_ROOT_DIR" ]; then
  export ACC_ROOT_DIR="$CONDA_PREFIX/share/bmad"
  export _CONDA_ACC_ROOT_DIR=1
fi

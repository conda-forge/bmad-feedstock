#!/usr/bin/env bash

if [ -n "$_CONDA_ACC_ROOT_DIR" ]; then
  unset ACC_ROOT_DIR
  unset _CONDA_ACC_ROOT_DIR
fi

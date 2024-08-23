#!/usr/bin/env bash

mkdir -p "$PREFIX"/share/bmad/

cp -R ./bmad-doc "$PREFIX"/share/bmad/
cp -R ./regression_tests "$PREFIX"/share/bmad/
cp -R ./code_examples "$PREFIX"/share/bmad/

mkdir -p "$PREFIX"/share/bmad/tao
cp -R ./tao/doc "$PREFIX"/share/bmad/tao/

mkdir -p "$PREFIX"/share/bmad/bmad
cp -R ./bmad/doc "$PREFIX"/share/bmad/bmad/

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d,
# causing them to be sourced when an environment with bmad-doc is
# activated/deactivated.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/bmad-doc-${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
donev

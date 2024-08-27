#!/usr/bin/env bash

set -x

mkdir -p share

cp -R ./bmad-doc share
cp -R ./regression_tests share
cp -R ./code_examples share

mkdir -p share/tao
cp -R ./tao/doc share/tao/

mkdir -p share/bmad
cp -R ./bmad/doc share/bmad/

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d,
# causing them to be sourced when an environment with bmad-doc is
# activated/deactivated.
for CHANGE in "activate" "deactivate"; do
  mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
  cp "${RECIPE_DIR}/bmad-doc-${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done

echo
echo "Directory skeleton:"
find share -type d | sed -e "s#$PREFIX#PREFIX#"

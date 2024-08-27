#!/usr/bin/env bash

set -x

SHARE="$PREFIX"/share/bmad

mkdir -p "$SHARE"

cp -R ./bmad-doc "$SHARE"
cp -R ./regression_tests "$SHARE"
cp -R ./code_examples "$SHARE"

mkdir -p "$SHARE"/tao
cp -R ./tao/doc "$SHARE"/tao/

mkdir -p "$SHARE"/bmad
cp -R ./bmad/doc "$SHARE"/bmad/

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d,
# causing them to be sourced when an environment with bmad-doc is
# activated/deactivated.
for CHANGE in "activate" "deactivate"; do
  mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
  cp "${RECIPE_DIR}/bmad-doc-${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done

echo
echo "Final list of docs:"
find -type f "$SHARE"
echo "Directory skeleton:"
find -type d "$SHARE"

#!/usr/bin/env bash

# MPI switches
if [[ "$mpi" != "nompi" ]]; then
  echo "**** Setting up util/dist_prefs with MPI"

  cat <<EOF >> util/dist_prefs
export DIST_F90_REQUEST="gfortran"
export ACC_PLOT_PACKAGE="pgplot"
export ACC_PLOT_DISPLAY_TYPE="X"
export ACC_ENABLE_OPENMP="Y"
export ACC_ENABLE_MPI="Y"
export ACC_FORCE_BUILTIN_MPI="Y"
export ACC_ENABLE_GFORTRAN_OPTIMIZATION="Y"
export ACC_ENABLE_SHARED="Y"
export ACC_ENABLE_FPIC="Y"
export ACC_ENABLE_PROFILING="N"
export ACC_SET_GMAKE_JOBS="2"
export ACC_CONDA_BUILD="Y"
export ACC_CONDA_PATH="$PREFIX"
export ACC_USE_MACPORTS="N"
EOF

else
  echo "**** Setting up util/dist_prefs"

  cat <<EOF >> util/dist_prefs
export DIST_F90_REQUEST="gfortran"
export ACC_PLOT_PACKAGE="pgplot"
export ACC_PLOT_DISPLAY_TYPE="X"
export ACC_ENABLE_OPENMP="Y"
export ACC_ENABLE_MPI="N"
export ACC_FORCE_BUILTIN_MPI="N"
export ACC_ENABLE_GFORTRAN_OPTIMIZATION="Y"
export ACC_ENABLE_SHARED="Y"
export ACC_ENABLE_FPIC="Y"
export ACC_ENABLE_PROFILING="N"
export ACC_SET_GMAKE_JOBS="2"
export ACC_CONDA_BUILD="Y"
export ACC_CONDA_PATH="$PREFIX"
export ACC_USE_MACPORTS="N"
EOF

fi

echo "**** Invoking dist_source_me"
source util/dist_source_me

echo "**** creating gfortran link "
ln -sf $BUILD_PREFIX/bin/$CONDA_TOOLCHAIN_HOST-gfortran $BUILD_PREFIX/bin/gfortran

rm -f $PREFIX/lib/liblapack95.so
cp $PREFIX/lib/lapack95.a $PREFIX/lib/liblapack95.a

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # for openmpi cross compilation
  export OPAL_PREFIX=$PREFIX
fi


echo "**** Invoking dist_build_production"
util/dist_build_production

cd regression_tests
mk tracking_method_test-exe
cd ..

# create folders if they don't exist yet
mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include/bmad
mkdir -p $PREFIX/share/doc/tao

# Fix rpath for MacOS (except cross-compile)
if [[ "$target_platform" == osx-* ]] && [[ "$target_platform" ==  "$build_platform" ]]; then
  echo "Fixing MacOS rpath with Python: ${CONDA_PYTHON_EXE}"
  ${CONDA_PYTHON_EXE} ${RECIPE_DIR}/fix_rpath_macos.py
fi

# ## Remove all test binaries
# rm -f production/bin/*test*

## install products
# binaries
cp -r production/bin/* $PREFIX/bin/.
# headers
cp -r production/include/* $PREFIX/include/. | true
# libraries
cp -r production/lib/* $PREFIX/lib/.
# fortran modules
cp -r production/modules/* $PREFIX/include/bmad/. | true
# tao documenation files
cp -r tao/doc $PREFIX/share/doc/tao/.

# Eliminate lib folder to avoid issues:
rm -rf production/lib
rm -rf production/bin

# Create auxiliary dirs
mkdir -p $PREFIX/etc/conda/activate.d
mkdir -p $PREFIX/etc/conda/deactivate.d

# Create auxiliary vars
ACTIVATE=$PREFIX/etc/conda/activate.d/bmad
DEACTIVATE=$PREFIX/etc/conda/deactivate.d/bmad

# Variable TAO_DIR is used by Tao to find auxiliary documentation files
echo "export TAO_DIR=\$CONDA_PREFIX/share/doc/tao/" >> $ACTIVATE.sh
echo "unset TAO_DIR" >> $DEACTIVATE.sh

unset ACTIVATE
unset DEACTIVATE

echo "**** build.sh DONE"


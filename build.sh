#!/bin/bash

src_dir=~/code/sarus-amd-hook-test
build_dir=${src_dir}/build

mkdir -p ${build_dir}
cd ${build_dir}
rm -f CMakeCache.txt
rm -rf CMakeFiles

cmake ${src_dir} \
  -D CMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -D CMAKE_BUILD_TYPE=Release \
  -Dhip_ROOT=$(spack location -i hip) \
  -Dhipblas_ROOT=$(spack location -i hipblas) \

  #-Drocsolver_ROOT=$(spack location -i rocsolver) \
  #-Drocblas_ROOT=$(spack location -i /4oux2nb) \
  #-DCMAKE_CXX_COMPILER=$(spack location -i hip)/bin/hipcc
  #-DCMAKE_CXX_COMPILER=clang

#!/bin/bash

src_dir=~/code/sarus-amd-hook-test
build_dir=${src_dir}/build

mkdir -p ${build_dir}
cd ${build_dir}
rm -f CMakeCache.txt
rm -rf CMakeFiles

# If installed with spack
hip_root=$(spack location -i hip)
hipblas_root=$(spack location -i hipblas)
llvmamd_root=$(spack location -i llvm-amdgpu)
rocrdev_root=$(spack location -i hsa-rocr-dev)
comgr_root=$(spack location -i comgr)

cmake ${src_dir} \
  -D CMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_PREFIX_PATH="${hip_root};${hipblas_root};${llvmamd_root};${rocrdev_root};${comgr_root}"

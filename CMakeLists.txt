cmake_minimum_required(VERSION 3.18)
project(sarus-amd-hook-test VERSION 0.1.0)
enable_language(CXX)

find_package(hip CONFIG REQUIRED)
find_package(hipblas CONFIG REQUIRED)

add_executable(main main.cpp)
target_link_libraries(main hip::host roc::hipblas)

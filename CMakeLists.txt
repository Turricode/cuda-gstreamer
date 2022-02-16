cmake_minimum_required(VERSION 3.21)
project(cuda_gstreamer CUDA)

set(CMAKE_CUDA_STANDARD 14)

add_library(cuda_gstreamer SHARED library.cu)

set_target_properties(cuda_gstreamer PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)

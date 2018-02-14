#!/bin/bash

set -eux

dnf install -y jsoncpp-devel python3-prompt_toolkit cmake ninja-build git gcc-c++

git clone -b cling-patches --depth=1 http://root.cern.ch/git/llvm.git src
cd src/tools
git clone --depth=1 http://root.cern.ch/git/cling.git
git clone -b cling-patches --depth=1 http://root.cern.ch/git/clang.git
cd -
mkdir build inst
cd build
cmake -DCMAKE_INSTALL_PREFIX=../inst ../src -GNinja -DCMAKE_BUILD_TYPE=Release
ninja install
cd -
rm -rf build

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=../inst .. -GNinja -DCMAKE_BUILD_TYPE=Release
ninja

export PYTHONPATH=$(readlink -f src/tools/clang/bindings/python)
export LD_LIBRARY_PATH=$(readlink -f inst/lib)
./inspector --version

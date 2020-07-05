#!/bin/bash
set -e

sudo apt-get install -y \
   libtool \
   cmake \
   automake \
   autoconf \
   make \
   ninja-build \
   curl \
   unzip \
   zip \
   virtualenv \
   build-essential \
   openjdk-8-jdk


wget https://dl.google.com/go/go1.14.2.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.14.2.linux-arm64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go get -u github.com/bazelbuild/buildtools/buildifier 
go get -u github.com/bazelbuild/buildtools/buildozer

mkdir bazel 

pushd bazel
wget https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel-3.1.0-dist.zip
unzip bazel-3.1.0-dist.zip
env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh
popd

git clone https://github.com/envoyproxy/envoy.git

pushd envoy

git checkout v1.13.3
bazel build -c opt //source/exe:envoy-static.stripped

popd

#!/bin/bash

VERSION=1.0rc2-1
ROOTDIR=caffe_${VERSION}

make all distribute
mkdir $ROOTDIR
mkdir -p $ROOTDIR/usr/bin
mkdir -p $ROOTDIR/usr/lib
mkdir -p $ROOTDIR/usr/lib/python2.7/dist-packages/caffe

mv distribute/bin/* $ROOTDIR/usr/bin
mv distribute/python/caffe/* $ROOTDIR/usr/lib/python2.7/dist-packages/caffe
mv distribute/python/lib/* $ROOTDIR/usr/lib/

# Control
mkdir $ROOTDIR/DEBIAN
echo '
Package: caffe
Version: 1.0rc2
Section: mathematics
Priority: optional
Architecture: amd64
Depends: libprotobuf-dev, libleveldb-dev, libsnappy-dev, libopencv-dev, libhdf5-serial-dev, protobuf-compiler, libboost-all-dev, python-dev, libgflags-dev, libgoogle-glog-dev, liblmdb-dev
Maintainer: Micah Chambers <micahc.vt@gmail.com>
Description: Caffe is a machine learning toolset.

' > $ROOTDIR/DEBIAN/control

dpkg-deb --build $ROOTDIR


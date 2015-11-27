#!/bin/bash
# Run from the caffe root directory, does not include python bindins, use
# setup.py for that

set -x
VERSION=1.0rc2-1
ARCH=amd64
ROOTDIR=`mktemp -d`/caffe-${VERSION}_${ARCH}

rm -fr $ROOTDIR
rm -fr distribute

make distribute
mkdir -p $ROOTDIR/usr/bin
mkdir -p $ROOTDIR/usr/lib
mkdir -p $ROOTDIR/usr/include

mv distribute/include/caffe $ROOTDIR/usr/include/
mv distribute/bin/* $ROOTDIR/usr/bin
mv distribute/lib/* $ROOTDIR/usr/lib/

# Control
mkdir $ROOTDIR/DEBIAN
echo "
Package: caffe
Version: ${VERSION}
Section: mathematics
Priority: optional
Architecture: ${ARCH}
Depends: libatlas-base-dev, libprotobuf-dev, libleveldb-dev, libsnappy-dev, libopencv-dev, libhdf5-serial-dev, protobuf-compiler, libboost-all-dev, python-dev, libgflags-dev, libgoogle-glog-dev, liblmdb-dev
Maintainer: Micah Chambers <micahc.vt@gmail.com>
Description: Caffe is a machine learning toolset.

" > $ROOTDIR/DEBIAN/control

dpkg-deb --build $ROOTDIR
mv ${ROOTDIR}.deb ./
# rm -fr $ROOTDIR

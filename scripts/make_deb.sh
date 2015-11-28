#!/bin/bash
# Run from the caffe root directory, does not include python bindings, use
# setup.py for that. debian/ubuntu package 'devscripts' to run
# Afterward you can upload the files somewhere, say
#
# http://world.com/hello/source/*
#
# then add the package to apt using (the trailing slashes are REQUIRED):
# deb-src http://world.com/hello/ source/
# debc http://world.com/hello/ binary/
#
# and get source or install binary using:
# $ sudo apt-get update
# $ sudo apt-get source caffe --allow-unauthenticated
# $ sudo apt-get install caffe --allow-unauthenticated

set -x
VERSION=1.0\~rc2
ROOTDIR=`mktemp -d`
SRCDIR=$ROOTDIR/caffe_${VERSION}
OUTDIR=$PWD

git clone . $SRCDIR

# Tar up and build
cd $ROOTDIR/
tar --exclude-vcs -czf caffe_${VERSION}.orig.tar.gz caffe_${VERSION}
cd $SRCDIR
debuild -us -uc

cd $ROOTDIR
rm $OUTDIR/source/* $OUTDIR/binary/*
rm -r $OUTDIR/source $OUTDIR/binary
mkdir source binary
mv *.deb binary
mv *.{dsc,debian.tar.gz,orig.tar.gz,diff.gz} source
dpkg-scanpackages binary /dev/null | gzip -9c > binary/Packages.gz
dpkg-scansources source /dev/null | gzip -9c > source/Sources.gz

mv binary source $OUTDIR

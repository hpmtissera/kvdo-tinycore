#!/usr/bin/env bash

set -e

KVDO_VERSION=$1
TC_KERNEL_VERSION=4.19.10-tinycore64
KERNEL_SOURCES_PATH=/usr/src/linux-4.19.10

if [ "${KVDO_VERSION}" = "" ]; then
   echo "Error: Must specify desired KVDO version."
   exit 1
fi

# When using a custom kernel build, Module.symvers, .config files should be copied from the kernel build
rm -rf /usr/src/linux-4.19.10
mkdir -p /usr/src
tar xvf /tmp/linux-4.19.10.tar.xz -C /usr/src/ > /dev/null

cp /opt/build/Module.symvers /usr/src/linux-4.19.10
cp /opt/build/.config /usr/src/linux-4.19.10

cd /usr/src/linux-4.19.10

make oldconfig
make prepare
make modules_prepare

make SUBDIRS=scripts/mod
cd -

git clone https://github.com/dm-vdo/kvdo.git
cd kvdo
git checkout ${KVDO_VERSION} -b ${KVDO_VERSION}

make -j$(nproc) -C ${KERNEL_SOURCES_PATH} M=$(pwd)
cd ..

mkdir -p kvdo-${TC_KERNEL_VERSION}/usr/local/lib/modules/${TC_KERNEL_VERSION}/kernel/kmod-vdo/uds
mkdir -p kvdo-${TC_KERNEL_VERSION}/usr/local/lib/modules/${TC_KERNEL_VERSION}/kernel/kmod-vdo/vdo

cp kvdo/uds/uds.ko kvdo-${TC_KERNEL_VERSION}/usr/local/lib/modules/${TC_KERNEL_VERSION}/kernel/kmod-vdo/uds
cp kvdo/vdo/kvdo.ko kvdo-${TC_KERNEL_VERSION}/usr/local/lib/modules/${TC_KERNEL_VERSION}/kernel/kmod-vdo/vdo

mksquashfs kvdo-${TC_KERNEL_VERSION} kvdo-${TC_KERNEL_VERSION}.tcz

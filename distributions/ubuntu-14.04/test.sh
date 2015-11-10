#!/bin/bash

#start xtreemfs servers
/etc/init.d/xtreemfs-dir start
/etc/init.d/xtreemfs-mrc start
/etc/init.d/xtreemfs-osd start

#create and mount volume
mkfs.xtreemfs localhost/test-volume
mkdir test_volume
echo "created directory"
mount.xtreemfs --max-tries=3 localhost/test-volume test_volume

if [ $? -ne 0 ]; then
    exit 1
fi

echo "mounted test volume"
#write
dd if=/dev/urandom of=test_volume/test.txt bs=4k count=256

if [ $? -ne 0 ]; then
    exit 1
fi

echo "written some random data to test volume"

#{{CUSTOMCOMMAND}}

#unmount volume
umount.xtreemfs test_volume

if [ $? -ne 0 ]; then
    exit 1
fi

echo "unmounted test volume"

#stop xtreemfs servers
/etc/init.d/xtreemfs-dir stop
/etc/init.d/xtreemfs-mrc stop
/etc/init.d/xtreemfs-osd stop

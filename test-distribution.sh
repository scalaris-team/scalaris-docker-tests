#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/distributions
CONTAINER_NAME="test-container"

docker pull ubuntu
docker pull opensuse
docker pull centos
docker pull fedora
docker pull debian


DISTRIBUTION_DIR=$1
ret=0
failed=""

# build docker image
docker build -t scalaris/$DISTRIBUTION_DIR $DIR/$DISTRIBUTION_DIR

# run docker container
docker run --name=$CONTAINER_NAME --privileged scalaris/$DISTRIBUTION_DIR ./test.sh

if [ $? -ne 0 ]; then
    ret=`expr $ret + 1`
    echo "$DISTRIBUTION_DIR test failed!"
    failed=$(printf "%s\n%s" "$failed" "$DISTRIBUTION_DIR")
fi

#remove container and image
docker rm $CONTAINER_NAME
docker rmi xtreemfs/$DISTRIBUTION_DIR

if [ $ret -ne 0 ]; then
    echo "The following tests failed: $failed"
fi

exit $ret

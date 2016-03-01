#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/distributions
CONTAINER_NAME="test-container"
DISTRIBUTION_DIR=$1


if [ "${DISTRIBUTION_DIR:0:6}" = "debian" ] ; then
  docker pull debian
fi

if [ "${DISTRIBUTION_DIR:0:6}" = "ubuntu" ] ; then
  docker pull ubuntu
fi

if [ "${DISTRIBUTION_DIR:0:6}" = "fedora" ] ; then
  docker pull fedora
fi

if [ "${DISTRIBUTION_DIR:0:6}" = "centos" ] ; then
  docker pull centos
fi

if [ "${DISTRIBUTION_DIR:0:8}" = "opensuse" ] ; then
  docker pull opensuse
fi


ret=0
failed=""

# copy test.sh
cp test.sh $DIR/$DISTRIBUTION_DIR

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
docker rmi scalaris/$DISTRIBUTION_DIR

if [ $ret -ne 0 ]; then
    echo "The following tests failed: $failed"
fi

exit $ret

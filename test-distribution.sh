#!/bin/bash

# usage: ./test-distributions.sh [ all| [distribution]* ]
# default: ./test.distibutions.sh all

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/distributions
CONTAINER_NAME="test-container"

# prepare distribution dirs
if [[ "$1" == "all" || "$1" == "" ]]; then
   DISTRIBUTION_DIRS=$(ls $DIR | grep "xtreemfs-")
else
  for i in $*; do DISTRIBUTION_DIRS="$DISTRIBUTION_DIRS $(ls $DIR | grep "xtreemfs-$i")"; done
fi

docker pull ubuntu
docker pull opensuse
docker pull centos
docker pull fedora
docker pull debian


DISTRIBUTION_DIR=$1
ret=0
failed=""

#run containers

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

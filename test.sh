#!/bin/bash

result=0

# use an IP-based nodename in cases where a FQDN is not available
NODE_NAME="-n node@127.0.0.1"

# new or old scalarisctl?
if scalarisctl --help | grep "\-t <stype>" >/dev/null  ; then
  START_TYPE_FIRST="-t first"
else
  START_TYPE_FIRST="-f -s"
fi

echo "Running scalarisctl checkinstallation..."
scalarisctl $NODE_NAME checkinstallation || result=1
echo "Starting run-time tests with scalarisctl..."
scalarisctl $START_TYPE_FIRST $NODE_NAME -m -d start || echo -e "\x1b[1;31m##### FAILED to start Scalaris #####\x1b[0m"

sleep 5s # wait for Scalaris to start

# interactively show web page with the following commands:
# xauth merge /tmp/xkey
# export DISPLAY=:0
# xdg-open http://127.0.0.1:8000/indexed-ring.yaws &> /dev/null
mkdir -p log && cd log
wget --timeout 5 -q --page-requisites http://localhost:8000/indexed-ring.yaws
wget_download=$?
mv "localhost:8000/indexed-ring.yaws" "localhost:8000/indexed-ring.html"
if [ $wget_download -gt 0 ] ; then
  echo -e "\x1b[1;31mScalaris web debug interface is not running (port 8000). Exit\x1b[0m"
  result=1
else
  echo -e "Scalaris web debug interface running (port 8000). OK so far"
fi
cd -

scalarisctl $START_TYPE_FIRST $NODE_NAME -m -d stop || echo -e "\x1b[1;31m##### FAILED to stop Scalaris #####\x1b[0m"

sleep 5s # wait for Scalaris to stop

number_nodes=1
skip_system_scalaris=no
if [ -x /etc/init.d/scalaris ]; then
echo "Starting run-time tests with init.d..."
  if [ -f /etc/init.d/scalaris-first ]; then
    number_nodes=2
    sed -e 's/SCALARIS_NODE=.*/SCALARIS_NODE="node@127.0.0.1"/g' -i /etc/scalaris/initd-first.conf
    /etc/init.d/scalaris-first start || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris-first #####\x1b[0m"; cat /var/log/scalaris/initd_node.log )
  else
    echo "{first, true}." >> /etc/scalaris/scalaris.local.cfg
  fi
  sed -e 's/SCALARIS_NODE=.*/SCALARIS_NODE="node1@127.0.0.1"/g' -i /etc/scalaris/initd.conf
  /etc/init.d/scalaris start || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris #####\x1b[0m"; cat /var/log/scalaris/initd_node1.log )
else
  echo -e "\x1b[1;34mATTENTION: systemd not supported with docker\x1b[0m" # in blue
  skip_system_scalaris=yes
#   echo "Starting run-time tests with systemctl..."
#   if [ -f /etc/conf.d/scalaris-first ]; then
#     number_nodes=2
#     sed -e 's/SCALARIS_NODE=.*/SCALARIS_NODE=node@127.0.0.1/g' -i /etc/conf.d/scalaris-first
#     systemctl start scalaris-first.service || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris-first #####\x1b[0m"; journalctl -xn50 --no-pager )
#   else
#     echo "{first, true}." >> /etc/scalaris/scalaris.local.cfg
#   fi
#   sed -e 's/SCALARIS_NODE=.*/SCALARIS_NODE=node1@127.0.0.1/g' -i /etc/conf.d/scalaris
#   systemctl start scalaris.service || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris #####\x1b[0m"; journalctl -xn50 --no-pager )
fi

if [ "$skip_system_scalaris" = "no" ]; then
  sleep 10s # wait for Scalaris to start

  mkdir -p log/initd && cd log/initd
  wget --timeout 5 -q --page-requisites http://localhost:8000/indexed-ring.yaws
  wget_download=$?
  mv "localhost:8000/indexed-ring.yaws" "localhost:8000/indexed-ring.html"
  if [ $wget_download -gt 0 ] ; then
    echo -e "\x1b[1;31mScalaris web debug interface is not running (port 8000). Exit\x1b[0m"
    result=1
  else
    echo -e "Scalaris web debug interface running (port 8000). OK so far"
  fi
  if [ "${number_nodes}" -eq 2 ] ; then
    wget --timeout 5 -q --page-requisites http://localhost:8001/ring.yaws
    wget_download=$?
    mv "localhost:8001/ring.yaws" "localhost:8001/ring.html"
    if [ $wget_download -gt 0 ] ; then
      echo -e "\x1b[1;31mScalaris-first web debug interface is not running (port 8001). Exit\x1b[0m"
      result=1
    else
      echo -e "Scalaris-first web debug interface running (port 8001). OK so far"
    fi
  fi
  cd -

  if [ -x /etc/init.d/scalaris ]; then
    if [ "${number_nodes}" -eq 2 ] ; then
      /etc/init.d/scalaris stop || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris #####\x1b[0m"; result=1 )
      /etc/init.d/scalaris-first kill || ( echo -e "\x1b[1;31m##### FAILED to kill Scalaris-first #####\x1b[0m"; result=1 )
    else
      /etc/init.d/scalaris kill || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris #####\x1b[0m"; result=1 )
    fi
    if [ "${result}" -ne 0 ] ; then
      cat /var/log/scalaris/initd_node*.log
    fi
  else
    systemctl stop scalaris.service || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris #####\x1b[0m"; result=1 )
    if [ "${number_nodes}" -eq 2 ] ; then
      systemctl stop scalaris-first.service || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris-first #####\x1b[0m"; result=1 )
    fi
    if [ "${result}" -ne 0 ] ; then
      journalctl -xn100 --no-pager
    fi
  fi
fi

if [ "${result}" -eq 0 ] ; then
  echo -e "\x1b[1;32mSUCCESS: All tests passed\x1b[0m" #green
fi

exit $result

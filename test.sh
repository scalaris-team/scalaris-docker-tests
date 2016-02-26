#!/bin/bash -x

/sbin/ifconfig

result=0

if scalarisctl --help | grep "\-t <stype>" >/dev/null  ; then
  START_TYPE_FIRST="-t first"
else
  START_TYPE_FIRST="-f -s"
fi

scalarisctl checkinstallation || result=1
scalarisctl $START_TYPE_FIRST -m -d start || echo -e "\x1b[1;31m##### FAILED to start Scalaris #####\x1b[0m"

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
  echo -e "\x1b[1;31mScalaris web debug interface is not running. Exit\x1b[0m"
  result=1
fi
cd -

scalarisctl $START_TYPE_FIRST -m -d stop || echo -e "\x1b[1;31m##### FAILED to stop Scalaris #####\x1b[0m"

sleep 5s # wait for Scalaris to stop

number_nodes=1
if [ -x /etc/init.d/scalaris ]; then
  if [ -f /etc/init.d/scalaris-first ]; then
    number_nodes=2
    /etc/init.d/scalaris-first start || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris-first via init.d script #####\x1b[0m"; cat /var/log/scalaris/initd_node.log )
  else
    echo "{first, true}." >> /etc/scalaris/scalaris.local.cfg
  fi
  /etc/init.d/scalaris start || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris via init.d script #####\x1b[0m"; cat /var/log/scalaris/initd_node1.log )
else
  if [ -f /etc/conf.d/scalaris-first ]; then
    number_nodes=2
    systemctl start scalaris-first.service || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris-first via systemctl #####\x1b[0m"; journalctl -xn50 --no-pager )
  else
    echo "{first, true}." >> /etc/scalaris/scalaris.local.cfg
  fi
  systemctl start scalaris.service || ( echo -e "\x1b[1;31m##### FAILED to start Scalaris via systemctl #####\x1b[0m"; journalctl -xn50 --no-pager )
fi
sleep 10s # wait for Scalaris to start

mkdir -p log/initd && cd log/initd
wget --timeout 5 -q --page-requisites http://localhost:8000/indexed-ring.yaws
wget_download=$?
mv "localhost:8000/indexed-ring.yaws" "localhost:8000/indexed-ring.html"
if [ $wget_download -gt 0 ] ; then
  echo -e "\x1b[1;31mScalaris web debug interface is not running (after starting via init.d/systemctl). Exit\x1b[0m"
  result=1
fi
if [ "${number_nodes}" -eq 2 ] ; then
  wget --timeout 5 -q --page-requisites http://localhost:8001/ring.yaws
  wget_download=$?
  mv "localhost:8001/ring.yaws" "localhost:8001/ring.html"
  if [ $wget_download -gt 0 ] ; then
    echo -e "\x1b[1;31mScalaris-first web debug interface is not running (after starting via init.d/systemctl). Exit\x1b[0m"
    result=1
  fi
fi
cd -

if [ -x /etc/init.d/scalaris ]; then
  if [ "${number_nodes}" -eq 2 ] ; then
    /etc/init.d/scalaris stop || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris via init.d script #####\x1b[0m"; result=1 )
    /etc/init.d/scalaris-first kill || ( echo -e "\x1b[1;31m##### FAILED to kill Scalaris-first via init.d script #####\x1b[0m"; result=1 )
  else
    /etc/init.d/scalaris kill || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris via init.d script #####\x1b[0m"; result=1 )
  fi
  if [ "${result}" -ne 0 ] ; then
    cat /var/log/scalaris/initd_node*.log
  fi
else
  systemctl stop scalaris.service || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris via systemctl #####\x1b[0m"; result=1 )
  if [ "${number_nodes}" -eq 2 ] ; then
    systemctl stop scalaris-first.service || ( echo -e "\x1b[1;31m##### FAILED to stop Scalaris-first via systemctl #####\x1b[0m"; result=1 )
  fi
  if [ "${result}" -ne 0 ] ; then
    journalctl -xn100 --no-pager
  fi
fi

exit $result

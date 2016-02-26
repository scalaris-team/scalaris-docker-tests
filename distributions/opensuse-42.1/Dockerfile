FROM opensuse:42.1
MAINTAINER Nico Kruber <kruber@zib.de>

RUN zypper in -y  wget

RUN zypper addrepo "http://download.opensuse.org/repositories/home:/scalaris:/svn/openSUSE_Leap_42.1/home:scalaris:svn.repo"

RUN zypper --non-interactive --gpg-auto-import-keys ref

RUN zypper in -y  scalaris

ADD test.sh /
RUN chmod +x test.sh

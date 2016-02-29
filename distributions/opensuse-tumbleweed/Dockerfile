FROM opensuse:tumbleweed
MAINTAINER Nico Kruber <kruber@zib.de>

RUN zypper in -y  wget

RUN zypper addrepo "http://download.opensuse.org/repositories/home:/scalaris:/testing/openSUSE_Tumbleweed/home:scalaris:testing.repo"

RUN zypper --non-interactive --gpg-auto-import-keys ref

RUN zypper in -y  scalaris scalaris-doc scalaris-java python-scalaris python3-scalaris ruby-scalaris erlang-erlang_js erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh

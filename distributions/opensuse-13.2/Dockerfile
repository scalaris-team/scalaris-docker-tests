FROM opensuse:13.2
MAINTAINER Nico Kruber <kruber@zib.de>

RUN zypper --non-interactive in wget

RUN zypper addrepo --refresh "http://download.opensuse.org/repositories/home:/scalaris:/testing/openSUSE_13.2/home:scalaris:testing.repo"

RUN zypper --non-interactive --gpg-auto-import-keys ref

RUN zypper --non-interactive in scalaris scalaris-doc scalaris-java python-scalaris python3-scalaris ruby-scalaris erlang-erlang_js erlang-hanoidb

ADD test.sh /
RUN chmod +x test.sh

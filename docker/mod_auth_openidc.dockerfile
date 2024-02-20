# syntax=docker/dockerfile-upstream:master-labs

# Compiles mod_auth_openidc

# docker image build -t my/mod_auth_openidc -f mod_auth_openidc.ockerfile .
# docker image build -t my/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=https://github.com/psteniusubi/mod_auth_openidc.git" .
#
# docker image build -t my/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=." ..
#
# docker container run --rm -it my/mod_auth_openidc
#

FROM ubuntu:22.04

WORKDIR /root

RUN <<EOT bash
apt-get update -y
apt-get install -y apache2-dev libcjose-dev libssl-dev check pkg-config libjansson-dev libcurl4-openssl-dev libhiredis-dev libpcre2-dev
EOT

ARG mod_auth_openidc="https://github.com/OpenIDC/mod_auth_openidc.git"
ADD $mod_auth_openidc /root/mod_auth_openidc

WORKDIR /root/mod_auth_openidc

RUN <<EOT bash
./autogen.sh
./configure
make
make check || (cat test-suite.log && exit -1)
make distcheck DESTDIR=/tmp/mod_auth_openidc
EOT

CMD [ "/bin/bash", "-l" ]

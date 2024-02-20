# syntax=docker/dockerfile-upstream:master-labs

# Runs Apache HTTP Server

# 
# docker image build -t my/httpd -f httpd.dockerfile .
# docker container run --rm -it -p 443:443 --name httpd my/httpd 
# docker container exec -it httpd /bin/bash -l
#
# docker container run --rm -it my/httpd /bin/bash -l
#
# curl -k -i https://localhost/cgi-bin/printenv
#

FROM my/mod_auth_openidc AS mod_auth_openidc

FROM httpd:2.4

RUN <<EOT bash
apt-get update -y
apt-get install -y libcjose0 libhiredis0.14
EOT

COPY --from=mod_auth_openidc /root/mod_auth_openidc/.libs/mod_auth_openidc.so /usr/local/apache2/modules/

COPY httpd.conf /usr/local/apache2/conf/
COPY example.com.pem /usr/local/apache2/conf/

EXPOSE 443/tcp

RUN <<EOT bash
mv /usr/local/apache2/cgi-bin/printenv /usr/local/apache2/cgi-bin/printenv.bak
echo '#!/usr/bin/perl' > /usr/local/apache2/cgi-bin/printenv
cat /usr/local/apache2/cgi-bin/printenv.bak >> /usr/local/apache2/cgi-bin/printenv
chmod +x /usr/local/apache2/cgi-bin/printenv
EOT

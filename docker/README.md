# mod_auth_openidc

## Compile

    docker image build -t my/mod_auth_openidc -f mod_auth_openidc.ockerfile .

## From fork

    docker image build -t my/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=https://github.com/psteniusubi/mod_auth_openidc.git" .

## From local sources

    docker image build -t my/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=." ..

## Debug

    docker container run --rm -it my/mod_auth_openidc

# Apache HTTP

## Create image

Get example.com.pem from PKI

    docker image build -t my/httpd -f httpd.dockerfile .

## Start

    docker container run --rm -it -p 443:443 --name httpd my/httpd 

### Test

Navigate to https://localhost/cgi-bin/printenv

    curl -k -i https://localhost/cgi-bin/printenv

## Debug

    docker container exec -it httpd /bin/bash -l

    docker container run --rm -it -p 443:443 --name httpd my/httpd /bin/bash -l

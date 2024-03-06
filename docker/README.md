# mod_auth_openidc

## Compile

    docker image build -t local/mod_auth_openidc -f mod_auth_openidc.dockerfile .

## From fork

    docker image build -t local/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=https://github.com/psteniusubi/mod_auth_openidc.git" .

## From local sources

    docker image build -t local/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=." ..

## Debug

    docker container run --rm -it local/mod_auth_openidc

# Apache HTTP

## Configuration

Generate OIDCProviderSignedJwksUri.conf, issuer.provider and issuer.conf files from entity statement

    pwsh -f get-entity-statement.ps1 -Uri https://login.io.ubidemo1.com/.well-known/openid-federation

## Create image

Get example.com.pem from PKI

    docker image build -t local/httpd -f httpd.dockerfile .

## Start

    docker container run --rm -it -p 443:443 --name httpd local/httpd httpd-foreground

### Test

Navigate to https://localhost/cgi-bin/printenv

    curl -k -i https://localhost/cgi-bin/printenv

## Start (OIDCMetadataDir)

    docker container run --rm -it -p 443:443 --name httpd local/httpd httpd-foreground -f conf/httpd-metadata.conf

    docker container run --rm -it -p 443:443 --name httpd local/httpd /bin/bash -l
    ./bin/httpd -DFOREGROUND -f conf/httpd-metadata.conf

### Test

Navigate to https://localhost/oidc/redirect?iss=https%3A%2F%2Flogin.io.ubidemo1.com%2Fuas&target_link_uri=https://localhost/cgi-bin/printenv

## Debug

    docker container run --rm -it -p 443:443 local/httpd /bin/bash -l

# Docker Compose

## Build

    docker compose build --build-arg "mod_auth_openidc=."
    docker compose build --build-arg "mod_auth_openidc=https://github.com/OpenIDC/mod_auth_openidc.git"

## Run with httpd.conf

    docker compose up httpd
    docker compose down

## Run with httpd-metadata.conf

    docker compose up httpd-metadata
    docker compose down

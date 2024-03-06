# mod_auth_openidc

## Compile

    docker image build -t local/mod_auth_openidc -f mod_auth_openidc.dockerfile .

## From fork

    docker image build -t local/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=https://github.com/psteniusubi/mod_auth_openidc.git" .

## From local sources

    docker image build -t local/mod_auth_openidc -f mod_auth_openidc.dockerfile --build-arg "mod_auth_openidc=." ..

## Debug

    docker container run --rm -it local/mod_auth_openidc

# Apache configuration

    conf/
        httpd-common.conf
        localhost.pem
    conf-jwks/
        httpd.conf
        httpd-metadatadir.conf
        OIDCProviderSignedJwksUri.conf
    conf-jwk/
        httpd.conf
        httpd-metadatadir.conf
        OIDCProviderSignedJwksUri.conf
    metadata-jwks/
        login.io.ubidemo1.com%2Fuas.client
        login.io.ubidemo1.com%2Fuas.conf
        login.io.ubidemo1.com%2Fuas.provider
    metadata-jwk/
        login.io.ubidemo1.com%2Fuas.client
        login.io.ubidemo1.com%2Fuas.conf
        login.io.ubidemo1.com%2Fuas.provider

## Signed JWKS

Generate OIDCProviderSignedJwksUri.conf, issuer.provider and issuer.conf files from entity statement

    pwsh -f get-entity-statement.ps1 -Uri https://login.io.ubidemo1.com/.well-known/openid-federation -OutDir jwks
    pwsh -f get-entity-statement.ps1 -Uri https://login.io.ubidemo1.com/.well-known/openid-federation -SingleJwk -OutDir jwk

## TLS

Get localhost.pem from PKI

# Docker Compose

## Build

    docker compose build --build-arg "mod_auth_openidc=."
    docker compose build --build-arg "mod_auth_openidc=https://github.com/OpenIDC/mod_auth_openidc.git"

## Run with jwks/httpd.conf

    docker compose up httpd-jwks
    docker compose down

## Run with jwks/httpd-metadatadir.conf

    docker compose up httpd-metadatadir-jwks
    docker compose down

## Run with jwk/httpd.conf

    docker compose up httpd-jwk
    docker compose down

## Run with jwk/httpd-metadatadir.conf

    docker compose up httpd-metadatadir-jwk
    docker compose down

## Debug

    docker compose run --rm -it httpd-jwks bash -l

### Test

Navigate to https://localhost/cgi-bin/printenv

    curl -k -i https://localhost/cgi-bin/printenv


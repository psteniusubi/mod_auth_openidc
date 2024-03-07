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

Select one of

    docker compose build --build-arg "mod_auth_openidc=."
    docker compose build --build-arg "mod_auth_openidc=https://github.com/psteniusubi/mod_auth_openidc.git#feat-signed-jwks-verifier-jwks"
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

## Test

Navigate to https://localhost/cgi-bin/printenv

## Debug

    docker compose run --rm -it httpd-jwks bash -l

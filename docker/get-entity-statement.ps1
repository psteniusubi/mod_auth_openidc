#Requires -Modules Ubisecure.Jose

<#

./get-entity-statement.ps1 -Uri https://login.io.ubidemo1.com/.well-known/openid-federation
./get-entity-statement.ps1 -Uri https://login.io.ubidemo1.com/.well-known/openid-federation -SingleJwk

#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $Uri,

    [Parameter()]
    [switch]
    $SingleJwk,

    [Parameter()]
    [string]
    $OutDir = "."
)
begin {
    Import-Module Ubisecure.Jose -ErrorAction Stop
    $null = New-Item $OutDir -ItemType Directory -Force -ErrorAction Stop
}
process {
    # fetch entity statement
    $jwt = Invoke-RestMethod -Uri $Uri -ErrorAction Stop
    $body = $null
    # read entity statement body
    if (-not (Test-Jws -InputObject $jwt -BodyOut ([ref]$body))) {
        throw [System.ArgumentException]::new()
    }
    $entity = $body | ConvertFrom-Json -Depth 8 -AsHashtable
    # keys from entity statement
    $jwks = $entity["jwks"] | ConvertTo-Json -Depth 8 -Compress
    # validate self-signed entity statement
    $entity = ConvertFrom-Jws -InputObject $jwt -Jwks $jwks -ErrorAction Stop | ConvertFrom-Json -Depth 8 -AsHashtable
    # select single verifier jwk (for testing jwks vs jwk)
    if ($SingleJwk) {
        $signedJwks = Invoke-RestMethod $entity["metadata"]["openid_provider"]["signed_jwks_uri"] -ErrorAction Stop
        $jwk = $null
        $null = $signedJwks | ConvertFrom-Jws -Jwks $jwks -JwkOut ([ref]$jwk) -ErrorAction Stop
        $jwks = $jwk
    }
    # get file name from issuer
    $issuer = $entity["metadata"]["openid_provider"]["issuer"]
    $name = [System.Text.Encodings.Web.UrlEncoder]::Default.Encode(($issuer -replace "^http(s)?://", ""))
    # remove jwks_uri (makes sure signed_jwks_uri is used)
    $null = $entity["metadata"]["openid_provider"].Remove("jwks_uri")
    # generate .provider file    
    $entity["metadata"]["openid_provider"] | ConvertTo-Json -Depth 8 | Out-File (Join-Path $OutDir "$name.provider") -Encoding utf8NoBOM
    # generate .conf file
    [ordered] @{ "signed_jwks_uri_key" = ($jwks | ConvertFrom-Json) } | ConvertTo-Json -Depth 8 | Out-File (Join-Path $OutDir "$name.conf") -Encoding utf8NoBOM
    # generate OIDCProviderSignedJwksUri.conf file
    $conf = @"
OIDCProviderSignedJwksUri $($entity["metadata"]["openid_provider"]["signed_jwks_uri"] | ConvertTo-Json) $($jwks | ConvertTo-Json)
"@ 
    $conf | Out-File (Join-Path $OutDir "OIDCProviderSignedJwksUri.conf") -Encoding ascii
}
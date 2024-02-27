#Requires -Modules Ubisecure.Jose

<#

./get-entity-statement.ps1 -Uri https://login.io.ubidemo1.com/.well-known/openid-federation

#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $Uri
)
begin {
    Import-Module Ubisecure.Jose
}
process {
    # fetch entity statement
    $jwt = Invoke-RestMethod -Uri $Uri
    $body = $null
    # read entity statement body
    if (-not (Test-Jws -InputObject $jwt -BodyOut ([ref]$body))) {
        throw [System.ArgumentException]::new()
    }
    $entity = $body | ConvertFrom-Json -Depth 8 -AsHashtable
    # validate self-signed entity statement
    $entity = ConvertFrom-Jws -InputObject $jwt -Jwks ($entity["jwks"] | ConvertTo-Json -Depth 8) -ErrorAction Stop | ConvertFrom-Json -Depth 8 -AsHashtable
    # get file name from issuer
    $issuer = $entity["metadata"]["openid_provider"]["issuer"]
    $name = [System.Text.Encodings.Web.UrlEncoder]::Default.Encode(($issuer -replace "^http(s)?://", ""))
    # remove jwks_uri (makes sure signed_jwks_uri is used)
    $null = $entity["metadata"]["openid_provider"].Remove("jwks_uri")
    # generate provider file    
    $entity["metadata"]["openid_provider"] | ConvertTo-Json -Depth 8 | Out-File "$name.provider" -Encoding utf8NoBOM
    # generate conf file
    [ordered] @{ "signed_jwks_uri_key" = $entity["jwks"] } | ConvertTo-Json -Depth 8 | Out-File "$name.conf" -Encoding utf8NoBOM
    # generate OIDCProviderSignedJwksUri.conf file
    $conf = @"
OIDCProviderSignedJwksUri $($entity["metadata"]["openid_provider"]["signed_jwks_uri"] | ConvertTo-Json) $($entity["jwks"] | ConvertTo-Json -Compress -Depth 8 | ConvertTo-Json)
"@ 
    $conf | Out-File "OIDCProviderSignedJwksUri.conf" -Encoding ascii
}
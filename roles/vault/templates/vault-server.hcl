disable_mlock = true
ui = true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "false"
  tls_cert_file = "/vault/file/SSLcertificate.crt"
  tls_key_file = "/vault/file/SSLprivatekey.key"
}

storage "s3" {
  access_key = "{{ s3_access_key }}"
  secret_key = "{{ s3_access_secret }}"
  bucket = "iyunbo-vault-dev"
  region = "eu-west-3"
}

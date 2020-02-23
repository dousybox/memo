#!/bin/bash
trap 'rm -f $KEYFILE' EXIT
KEYFILE=$(mktemp) || exit 1
name=$(git config user.name)
email=$(git config user.email)
hostName=$(hostname)
read -p "enter the platform name: " platformName
cat > $KEYFILE <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Key-Usage: sign
Subkey-Type: RSA
Subkey-Length: 4096
Subkey-Usage: encrypt
Name-Real: $name
Name-Comment: $hostName@$platformName
Name-Email: $email
Expire-Date: 0
EOF
gpgkeyInfo=($(gpg --batch --generate-key $KEYFILE 2>&1))
gpg --armor --export ${gpgkeyInfo[2]} | clip
echo The new generated public key has been copied to your clipboard.
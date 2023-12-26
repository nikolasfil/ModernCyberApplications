#!/bin/bash

if [ $# -lt 2 ]; then $
    >&2 echo "Usage: $0 [Sender] [Receiver]"
    exit 1
fi

sender=$1
receiver=$2

if [ ! -d "${sender}_decrypted" ]; then
    mkdir "${sender}_decrypted"
    echo "Created ${sender}_decrypted"
fi

# $1 is the original sender
# ${receiver} is the original receiver

# Unbasing
echo -e "\n\n ┌─ Unbasing ─┐ \n\n"

openssl base64 -d -in "${sender}/${sender}_msg.b64" -out "${sender}_decrypted/d_msg.bin"
echo "Unbased ${sender}/${sender}_msg.b64 to ${sender}_decrypted/d_msg.bin"
if [ -f "${sender}/${sender}_msg.digest.b64" ]; then
    openssl base64 -d -in "${sender}/${sender}_msg.digest.b64" -out "${sender}_decrypted/d_msg.digest.bin"
fi
if [ -f "${sender}/${sender}_msg.signature.b64" ]; then
    openssl base64 -d -in "${sender}/${sender}_msg.signature.b64" -out "${sender}_decrypted/d_msg.signature.bin"
fi

openssl base64 -d -in "${sender}/${sender}_randomkey.enc.b64" -out "${sender}_decrypted/d_randomkey.enc.bin"

echo -e " └─ Unbasing ─┘ \n\n"

# Decrypt The Key
echo -e "\n\n ┌─ Decrypt The Key  ─┐ \n\n"


# openssl rsautl -decrypt -inkey "${receiver}/${receiver}_private.pem" -in "${sender}_decrypted/d_randomkey.enc.bin" -out "${receiver}/${receiver}_randomkey.bin"
openssl pkeyutl -decrypt -inkey "${receiver}/${receiver}_dem" -in "${sender}_decrypted/d_randomkey.enc.bin" -out "${sender}_decrypted/${receiver}_randomkey.bin"
# rm "${sender}_decrypted/d_randomkey.enc.bin"

echo -e " └─ Decrypt The Key ┘ \n\n"

# Decrypt the file

echo -e "\n\n ┌─ Decrypt the file ─┐ \n\n"

# openssl enc -d -aes-256-cbc -in "${sender}_decrypted/d_msg.bin" -out "${sender}_decrypted/d_msg.txt" -pass file:"./${receiver}/${receiver}_randomkey.bin" -pbkdf2
# openssl enc -d -aes-256-cbc -in "${sender}_decrypted/d_msg.bin" -out "${sender}_decrypted/d_msg.txt" -pass file:"./${sender}_decrypted/d_randomkey.bin" -pbkdf2
openssl enc -d -aes-256-cbc -in "${sender}_decrypted/d_msg.bin" -out "${sender}_decrypted/d_msg.txt" -pass file:"./${sender}_decrypted/${receiver}_randomkey.bin" -pbkdf2


echo -e " └─ Decrypt the file ┘ \n\n"

if [ -f "${sender}_decrypted/d_msg.digest.bin" ]; then
    # Verification
    echo -e "\n\n ┌─ Verification ─┐ \n\n"
    
    cat "${sender}_decrypted/d_msg.txt" | openssl dgst -sha256 -binary | xxd -p > "${sender}_decrypted/d_msg.digest2.bin"
    
    # Find diff
    
    diff "${sender}_decrypted/d_msg.digest.bin"  "${sender}_decrypted/d_msg.digest2.bin"
    
    echo -e " └─ Verification ┘ \n\n"
fi


if [ -f "${sender}_decrypted/d_msg.signature.bin" ]; then
    # Verifying the Signature
    echo -e "\n\n ┌─ Verifying the Signature ─┐ \n\n"
    
    openssl dgst -sha256 -verify "${sender}/${sender}_public.pem"  -signature "${sender}_decrypted/d_msg.signature.bin" "${sender}_decrypted/d_msg.digest.bin"
    
    echo -e " └─ Verifying the Signature ┘ \n\n"
fi



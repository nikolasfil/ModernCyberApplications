# #!/bin/bash



creator(){
    echo -e "\n\n ┌─ Creating Folder ─┐ \n\n";
    
    mkdir "$1";
    # cd "$1";
    
    
    # Generating Private Key
    echo -e "\n\n ┌─  Generating Private Key ─┐ \n\n"
    
    openssl genrsa -aes256 -out "$1/$1_private.pem" 4096
    
    
    # Generating public Key :
    echo -e "\n\n ┌─ Generating public Key ─┐ \n\n "
    
    openssl rsa -in "$1/$1_private.pem" -outform PEM -pubout -out "$1/$1_public.pem"
    
    # Creating the file
    echo -e "\n\n ┌─ Creating File ─┐ \n\n"
    
    echo "Hello world: $1" > "$1/$1_msg.txt"
    
    # Random Key
    echo -e "\n\n ┌─ Creating Random Key ─┐ \n\n"
    
    openssl rand 64 > "$1/$1_randomkey.bin"
    
    # Encrypt Message :
    echo -e "\n\n ┌─ Encrypting Message ─┐ \n\n"
    
    openssl enc -aes-256-cbc -salt -in "$1/$1_msg.txt" -out "$1/$1_msg.bin" -pass file:./"$1/$1_randomkey.bin" -pbkdf2
    
    # Prepare the encrypted msg.bin
    openssl base64 -in "$1/$1_msg.bin" -out "$1/$1_msg.b64"
    
};


encryptor(){
    
    
    # Using a second public key to encrypt our public key
    echo -e "\n\n ┌─ Encrypt with the public key provided ─┐ \n\n"
    
    # openssl rsautl -encrypt -inkey "$2" -pubin -in "$1/$1_randomkey.bin" -out "$1/$1_randomkey.enc.bin"
    openssl pkeyutl -encrypt -inkey "$2" -pubin -in "$1/$1_randomkey.bin" -out "$1/$1_randomkey.enc.bin"
    # ls;
    
    openssl base64 -in "$1/$1_randomkey.enc.bin" -out "$1/$1_randomkey.enc.b64"
    
    
    # Creating a hash digest
    echo -e "\n\n ┌─ Creating Hash ─┐ \n\n"
    
    cat "$1/$1_msg.txt" | openssl dgst -sha256 -binary | xxd -p > "$1/$1_msg.digest.txt"
    
    openssl base64 -in "$1/$1_msg.digest.txt" -out "$1/$1_msg.digest.b64"
    
    
    # Making a Cryptographic Signature
    echo -e "\n\n ┌─ Creating Cryptographic Signature ─┐ \n\n"
    
    openssl dgst -sha256 -sign "$1/$1_private.pem" -out "$1/$1_msg.signature.bin" "$1/$1_msg.digest.txt"
    
    openssl base64 -in "$1/$1_msg.signature.bin" -out "$1/$1_msg.signature.b64"
    
    
};


zipper(){
    
    # Zipping the results
    echo -e "\n\n ┌─ Zipping ─┐ \n\n"
    zip "$1/$1.zip" "$1/$1_msg.b64" "$1/$1_msg.digest.b64" "$1/$1_msg.signature.b64" "$1/$1_randomkey.enc.b64" "$1/$1_public.pem"
    
};





if [ $# -eq 0 ]; then $
    >&2 echo -e "Usage: $0 [Name] [public_key] \n"
    exit 1
    elif [ $# -eq 1 ]; then
    
    creator $1;
    elif [ $# -eq 2 ]; then
    if [ ! -d "$1" ];then
        creator  $1;
        # else
        # cd "$1";
    fi
    
    encryptor $1 $2 ;
    zipper $1;
fi
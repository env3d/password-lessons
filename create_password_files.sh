#!/bin/bash

# 
# This script generates instructional password files
#

USERNAME_URL='https://raw.githubusercontent.com/insidetrust/statistically-likely-usernames/master/john.txt'
PASSWORD_URL='https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt'

# Retrieve the first 100 common usernames and passwords, randomize and combine into passwd_plain
COMMON_USERNAMES=$(curl -s $USERNAME_URL | head -n 100)
COMMON_PASSWORDS=$(curl -s $PASSWORD_URL | head -n 100 | shuf)

PLAIN=$(    
    for I in {1..100}
    do
	echo "$COMMON_PASSWORDS" | tail -n +$(( $RANDOM % 10 )) | head -n 1
    done
)
paste -d ':' <(echo "$COMMON_USERNAMES") <(echo "$PLAIN") > passwd_plain.txt


# We want some repeated passwords
COMMON_PASSWORDS=$(echo "$COMMON_PASSWORDS" | shuf)

# Create 100 SHASUMS
SHASUMS=$(    
    for I in {1..100}
    do
	#if [ $(( $RANDOM % 10 )) -gt 6 ]
	#then
	#    echo "$COMMON_PASSWORDS" | head -n 1 | sha256sum | cut -f 1 -d ' '
	#else
	#    echo "$COMMON_PASSWORDS" | tail -n +$I | head -n 1 | sha256sum | cut -f 1 -d ' '
	#fi
	echo "$COMMON_PASSWORDS" | tail -n +$(( $RANDOM % 10 )) | head -n 1 | sha256sum | cut -f 1 -d ' '
    done
)

paste -d ':' <(echo "$COMMON_USERNAMES") <(echo "$SHASUMS") > passwd_sha.txt

# Create 100 SALTED
SALTED=$(    
    for I in $COMMON_USERNAMES
    do	
	echo "$COMMON_PASSWORDS" | tail -n +$(( $RANDOM % 10 )) | head -n 1 | xargs -I {} htpasswd -2nb $I {}
#	echo $I
    done
)

echo "$SALTED" | grep -v '^$' > passwd_salted.txt


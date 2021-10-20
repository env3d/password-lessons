#!/bin/bash

#
# A naive way to break passwords hashed with sha256sum
#

# The pool of passwords comes from the first 100 common passwords
PASSWORD_URL='https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt'
COMMON_PASSWORDS=$(curl -s $PASSWORD_URL | head -n 100)

# We now read the password file.  For each login, we try the sha256sum of each of the common password
for IDPASS in $(cat passwd_sha.txt)
do
    ID=$(echo $IDPASS | cut -f 1 -d ':')
    TARGET=$(echo $IDPASS | cut -f 2 -d ':')
    for PASS in $COMMON_PASSWORDS
    do
	# if PASS == TARGET, we cracked it!
	if [ $(echo "$PASS" | sha256sum | cut -f 1 -d ' ') == "$TARGET" ]
	then
	    echo "$ID has the password $PASS"
	fi
    done
done

# Password Management

## Q1
Notice that for simplicity purposes, the script 
[https://github.com/env3d/jwt-lessons/blob/main/02-hmac-token.sh](https://github.com/env3d/jwt-lessons/blob/main/02-hmac-token.sh)
does not actually check for passwords.  In this exercise, we explore how passwords are stored.

The simplest way to store passwords is by storing it as simple name-value pairs, something like this passwd_plain.txt.

Make a copy of the 02-hmac-token.sh script, call it q1.sh, and modify it so that your script would check both the 
username and password against the password file [passwd_plain.txt](passwd_plain.txt.).

If the id/password combination does not exist in the passwd_plain.txt file, you will return status 401.  
Otherwise, your script would return a JWT token.

Deploy the script to a web server, and provide an example curl call.

## Q2
Using plain text to store passwords is very insecure.  If a malicious hacker got a hold of the file, 
the hacker would gain access to all the actual passwords.  A better way to store passwords is to store 
them as hashes.  The file [passwd_sha.txt](passwd_sha.txt) stores passwords as sha256sum.  
Since sha256sum is a one-way hash, getting a hold of the password file does not mean you’ll have access 
to the actual password.

Make a copy of q1.sh and call it q2.sh.  Then modify q2.sh so that it checks against the sha256sum instead 
of the plain text file.

Since you don't have access to the original passwords, it's actually really difficult to test your login script 
against the passwd_sha.txt file.  Create a new entry in the passwd_sha.txt so you can test your q2.sh properly.  

## Q3
Using hash as password storage is much more secure than plain text, since even if a hacker has access to the password 
file (or database), they would not know the actual password. 

However, since we are using a simple sha256sum, the hacker can still recover the original passwords by repeatedly 
running sha256sum on a potential set of passwords, then comparing it against the password file.  A naive 
approach can be found in [naive_crack.sh](naive_crack.sh).

When you pre-compute hashes in order to perform a brute force attack (aka dictionary attack), the 
pre-computed hash is called a "rainbow table".  

Write a script to recover all the passwords using this "rainbow table" concept.
Instead of recomputing the sha256sum every single loop, we pre-compute them before the loop begins.  
Call this solution q3.sh.

HINT: double loops are very slow, but grep is very fast.  Once you have computed the "rainbow table", 
you can grep the hash to make your program faster.

## Q4
To mitigate the "rainbow table" attack highlighted in Q3, passwords are usually "salted".

The current best practice is to use the blowfish/bcrypt algorithm where the password and 
salt are generated together.  The openssl command will produce such a password for you.  
You can run the openssl command as follows:

```
[ec2-user@ip-172-31-13-169 password-lessons]$ openssl passwd -1 12345
$1$X4gWLB5H$MBKnn5VEYuyoN6cS7bQo2/

[ec2-user@ip-172-31-13-169 password-lessons]$ openssl passwd -1 12345
$1$/6avCSjQ$6A31CMaSwmmzOxYlpHxrY1

[ec2-user@ip-172-31-13-169 password-lessons]$ openssl passwd -1 12345
$1$vN2MROPo$7pZX4h7r2v1KrCJJ8ndAb/
```

Notice how the output has different hash value for the same password?  That's because the random 
salt is integrated into the password hash itself.  The output string is delimited by the $ character and
has the following format:

${algorithm}${salt}${hash}

We use the -1 algorithm to encrypt passwords, and the salt value is randomly assigned.

If we know the salt, we can verify a password by providing a specific salt value to openssl,
as follows:

```
[ec2-user@ip-172-31-13-169 password-lessons]$ openssl passwd -1 -salt vN2MROPo 12345
$1$vN2MROPo$7pZX4h7r2v1KrCJJ8ndAb/
```

The file passwd_salted.txt contains passwords encrypted using `openssl passwd` as seen above.  Create a copy of your q2.sh 
script and call it q4.sh, then modify q4.sh script to work with [passwd_salted.txt](passwd_salted.txt).


# certbot transip helper
This helper can be used in combination with certbot in a way it is shown in `call_certbot.sh`. But some settings have to be set correctly to make it work for you.

1. Login to https://www.transip.nl/cp/account/api/ generate a key and store it in a file.
2. Create a file `.certbot_transip_helper.ini` in your homedir it should have a content something like this:
   ```
   [DEFAULT]
   login = transip_username
   keyfile = /some/dir/transip.pem
   ```
3. Certbot shoult be installed.
4. Make sure all the nessecary Python packages are installed.
5. After adjusting `call_certbot.sh` or any other script of your choosing you can make use of it.

Certbot will call the script and create the requested TXT dns entry to validate. After validation the record will be removed again.

It works for wildcard certificates.

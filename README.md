# certbot transip helper

This helper can be used in combination with certbot in a way it is shown in `call_certbot.sh`. But some settings have to be set correctly to make it work for you.

1. Login to <https://www.transip.nl/cp/account/api/> generate a key and store it in a file.
2. Create a file `.certbot_transip_helper.ini` in your homedir it should have a content something like this:

   ```text
   [DEFAULT]
   login = transip_username
   keyfile = /some/dir/transip.pem
   ```

3. Install Certbot <https://certbot.eff.org/instructions>
4. Make sure all the necessary Python packages are installed.

   ```bash
   pip3 install -r requirements.txt
   ```

5. For testing purposes  `test.sh` can be used.

   **Validation of the text record can take some time, depending of DNS record propagation.**

   **`test.sh` and certificate request cannot run at the same time, it uses the same TXT record!**

   Call test.sh in the following way:
   ```bash
   DOMAIN_NAME=example.com ./test.sh
   ```

   **test.sh output:**

   ```bash
   0 entries found which have to be removed
   Removing:
   Entry for _acme-challenge.example.com created
   Waiting for getting succesfull DNS result: ..............................
   Entry resolved succesfully
   ```

7. Set some environment variables

   ```bash
   export CERTBOT_ENV=live       # This is optional, when not set it will use the staging environment of letsencrypt
   export EMAIL=user@example.com # Emailadress for revoking cert
   export DOMAIN=example.com     # Domain for which the certificate has to be generated
   export SUB_DOMAIN=www         # Entry for which the certificate has to be generated, '*' can be used for wildcard certificate
   export FORCE_CERT_RENEW=True  # This is optional, when set it will force new certificate generation
   ```

8. Now you can run `call_certbot.sh` or any other script of your choosing you can make use of it.

   **`call_certbot.sh` uses staging by default, change if necessary.**

Certbot will call the script and create the requested TXT dns entry to validate. After validation the record will be removed again.

It works for wildcard certificates.

## When making use of the docker image this should be done with some adaptations

Create a transip.pem file which should be used to login to the API of transip

Make use of the following ini file and only change the login. The keep the setting of the keyfile

   ```text
   [DEFAULT]
   login = transip_username
   keyfile = /home/certbot/transip.pem
   ```

Create a directory where the certs can be created this should be writable for user with ID 1000

Docker run with the next command

```bash
docker run \
-v ~/transip.pem:/home/certbot/transip.pem \
-v ~/.certbot_transip_helper.ini:/home/certbot/.certbot_transip_helper.ini \
-v $PWD/certs:/home/certbot/certs \
-e CERTBOT_ENV=live \
-e EMAIL=domain@exmaple.com \
-e DOMAIN=example.com \
-e SUB_DOMAIN=* \
ghcr.io/jeromba6/certbot_transip_helper/certbot_transip_helper:1.2.6
```

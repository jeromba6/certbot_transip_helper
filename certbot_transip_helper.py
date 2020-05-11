#!/usr/bin/env python3

import configparser
import dns.resolver  # pip3 install dnspython
import json
import os
import time
import transipApiV6

certbot_domain = os.getenv('CERTBOT_DOMAIN')
certbot_validation = os.getenv('CERTBOT_VALIDATION')
certbot_auth_output = os.getenv('CERTBOT_AUTH_OUTPUT')
acme_entry = '_acme-challenge'

config_file = os.path.expanduser('~') + '/.certbot_transip_helper.ini'
config = configparser.ConfigParser()
if len(config.read(config_file)) != 1:
    print('Configfile "{}" not found'.format(config_file))
    exit(1)

if 'DEFAULT' not in config:
    print('No "DEFAULT" section in "{}"'.format(config_file))
    exit(1)

if 'login' not in config['DEFAULT']:
    print('No "login" in "DEFAULT" section in "{}"'.format(config_file))
    exit(1)

if 'keyfile' not in config['DEFAULT']:
    print('No "keyfile" in "DEFAULT" section in "{}"'.format(config_file))
    exit(1)

login = config['DEFAULT']['login']

key_file = open(config['DEFAULT']['keyfile'], "r")
key = key_file.read()
key_file.close()

# Get Header for authentication against transip api V6
headers = transipApiV6.Generic(login, key).get_headers()

# Request domains managed by this account
domains=transipApiV6.Domains(headers)

# Request DNS entries for this domain
dns_entries = domains.list_dns_entries(certbot_domain)
# Find entry
found_dns_entries = []
for dns_entry in dns_entries['dnsEntries']:
  if dns_entry['name'] == acme_entry and dns_entry['type'] == 'TXT':
      found_dns_entries.append(dns_entry)

# Remove found entries
print('{} entries found which have to be removed'.format(len(found_dns_entries)))
print('Removing: ',end='')
for dns_entry in found_dns_entries:
  domains.delete_dns_entry(certbot_domain,'{"dnsEntry": ' + json.dumps(dns_entry) + '}')
  print('.',end='')
print()

# Add entry when needed
if certbot_auth_output is None:
  data = '''{
    "dnsEntry": {
      "name": "''' + acme_entry + '''",
      "expire": 60,
      "type": "TXT",
      "content": "''' + certbot_validation + '''"
    }
  }
  '''
  domains.add_dns_entry(certbot_domain, data)
  print('Entry for {}.{} created'.format(acme_entry,certbot_domain))
  sleep_interval = 10
  max_tries = 100
  failed = True
  print('Waiting for getting succesfull DNS result: ',end='')
  for x in range (max_tries):
      try:
          print('.',end='')
          time.sleep(sleep_interval)
          res = str(dns.resolver.query(acme_entry + '.' + certbot_domain, "TXT").response.answer[0][-1]).replace('"','')
          if certbot_validation == res:
              failed = False
              print()
              break
      except:
          pass

if failed:
    print()
    print('Checking for DNS change succesfull failed.')
    exit(1)
print('Entry resolved succesfully')

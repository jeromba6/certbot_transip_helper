FROM certbot/certbot:v1.32.2
COPY call_certbot.sh certbot_transip_helper.py requirements.txt /opt/certbot/

RUN adduser -D certbot ; \
mkdir /home/certbot/certs ; \
chown certbot: /home/certbot/ -R ; \
su - certbot -c 'pip install --upgrade pip' ; \
su - certbot -c 'pip install -r /opt/certbot/requirements.txt' ; \
ln -s /opt/certbot /opt/certbot_transip_helper ; \
rm /opt/certbot/requirements.txt

USER certbot
WORKDIR /home/certbot
ENTRYPOINT [ "/opt/certbot/call_certbot.sh" ]
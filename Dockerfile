FROM certbot/certbot:v2.8.0
COPY call_certbot.sh certbot_transip_helper.py requirements.txt /opt/certbot/

RUN adduser -D certbot ; \
mkdir /home/certbot/certs ; \
chown certbot: /home/certbot/ -R ; \
pip install --upgrade pip ; \
su - certbot -c 'pip install -r /opt/certbot/requirements.txt' ; \
rm /opt/certbot/requirements.txt

USER certbot
WORKDIR /home/certbot
ENTRYPOINT [ "/opt/certbot/call_certbot.sh" ]
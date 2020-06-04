FROM certbot/certbot:v1.5.0
COPY call_certbot.sh certbot_transip_helper.py /opt/certbot/

RUN pip3 install transipApiV6 dnspython ; \
adduser -D certbot ; \
mkdir /home/certbot/certs ; \
chown certbot: /home/certbot/ -R

USER certbot
WORKDIR /home/certbot
ENTRYPOINT [ "/opt/certbot/call_certbot.sh" ]
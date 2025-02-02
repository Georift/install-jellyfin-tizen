FROM vitalets/tizen-webos-sdk

COPY entrypoint.sh profile.xml tizencertificates/requirements.txt tizencertificates/cert_server.py tizencertificates/certtool.py ./

# Install dependencies
RUN apt update && apt install jq python3-pip -y && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/*
RUN pip3 install -r requirements.txt

RUN chown developer:developer entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/home/developer/entrypoint.sh" ]

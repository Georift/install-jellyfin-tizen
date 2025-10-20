FROM vitalets/tizen-webos-sdk
COPY --from=ghcr.io/astral-sh/uv:0.9.4 /uv /uvx /bin/

EXPOSE 4794

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY entrypoint.sh profile.xml install_python.sh tizencertificates ./

RUN mkdir /home/developer/templates
COPY tizencertificates/tizencertificates/templates/completion.html /home/developer/templates/completion.html

# Install additional dependencies (jq is still needed)
RUN apt update && apt install jq -y && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/*

RUN chown developer:developer entrypoint.sh
RUN chmod +x entrypoint.sh

# Sets the certificate and distrobutor password with an env variable
ENV CERT_PASSWORD=8VzdJWON1KaW3IRKrie7rDkovaqVciyG3xYiNWhzJE

# Inserts the CERT_PASSWORD vsriable into the pass: segment of the cert_server.py
RUN sed -i "s/pass:/pass:$CERT_PASSWORD/" tizencertificates/cert_server.py 

# removes every encountering of the -legacy flag as openssl in this container does not support it anymore
RUN sed -i "s/-legacy//g" tizencertificates/cert_server.py

ENTRYPOINT [ "/home/developer/entrypoint.sh" ]

FROM vitalets/tizen-webos-sdk

EXPOSE 4794

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY entrypoint.sh profile.xml install_python.sh tizencertificates/requirements.txt tizencertificates/cert_server.py tizencertificates/certtool.py ./

# Install additional dependencies (jq is still needed)
RUN apt update && apt install jq -y && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/*

RUN chown developer:developer install_python.sh
RUN chmod +x install_python.sh

RUN ./install_python.sh

RUN pip install --no-cache-dir -r requirements.txt

RUN chown developer:developer entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/home/developer/entrypoint.sh" ]
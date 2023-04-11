FROM debian:bullseye-slim

ARG UID=1001
ARG GID=1001

LABEL maintainer="jonathan@pressler.tech"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y java-common python3 python3-venv python3-pip wget libpq-dev git && \
    groupadd -g "${GID}" anvil && \
    useradd --create-home --no-log-init -u "${UID}" -g "${GID}" anvil && \
    mkdir /home/anvil/anvil_data && \
    chown -R anvil:anvil /home/anvil

RUN wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.deb && \
    dpkg -i amazon-corretto-11-x64-linux-jdk.deb && \
    rm amazon-corretto-11-x64-linux-jdk.deb

USER anvil:anvil

WORKDIR /home/anvil

RUN git clone https://github.com/jonp92/Milliner.git && \
    python3 -m venv /home/anvil/.anvil_app && \
    /home/anvil/.anvil_app/bin/pip install -U pip && \
    /home/anvil/.anvil_app/bin/pip install anvil-app-server python-dateutil bcrypt && \
    rm -rf /home/anvil/.cache/pip

VOLUME ["/home/anvil/anvil_data"]

EXPOSE 3030

CMD ["--port", "3030"]

ENTRYPOINT ["/home/anvil/.anvil_app/bin/anvil-app-server", "--app", "/home/anvil/Milliner", "--auto-migrate", "--data-dir=/home/anvil/anvil_data"]

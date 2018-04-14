FROM alpine:3.5

RUN apk add --update --no-cache bash ca-certificates python3 \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --upgrade pip setuptools \
    && update-ca-certificates \
    && rm -r /root/.cache

ENV DEVPI_SERVER_VERSION=4.3.0 \
    DEVPI_WEB_VERSION=3.2.0 \
    DEVPI_CLIENT_VERSION=3.0.0 \
    DEVPI_CLEANER_VERSION=0.2.0 \
    DEVPI_SEMANTIC_UI_VERSION=0.2.2 \
    DEVPI_THEME=semantic-ui \
    DEVPI_SERVERDIR=/devpi/server \
    DEVPI_CLIENTDIR=/devpi/client

RUN apk add --no-cache --virtual .build-deps gcc python3-dev libffi-dev musl-dev \
    && pip install devpi-server==$DEVPI_SERVER_VERSION \
           devpi-web==$DEVPI_WEB_VERSION \
           devpi-client==$DEVPI_CLIENT_VERSION \
           devpi-cleaner==$DEVPI_CLEANER_VERSION \
           devpi-semantic-ui==$DEVPI_SEMANTIC_UI_VERSION \
    && rm -r /root/.cache

COPY start.sh /
CMD ["/start.sh"]

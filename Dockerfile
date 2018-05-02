FROM python:2.7-alpine

RUN apk update && apk upgrade && \
    apk add \
        gcc python python-dev py-pip \
        # greenlet
        musl-dev \
        # sys/queue.h
        bsd-compat-headers \
        # event.h
        libevent-dev \
    && rm -rf /var/cache/apk/*

# want all dependencies first so that if it's just a code change, don't have to
# rebuild as much of the container
ADD requirements.txt /opt/requestbin/
RUN pip install -r /opt/requestbin/requirements.txt \
    && rm -rf ~/.pip/cache

# the code
ADD requestbin  /opt/requestbin/requestbin/

EXPOSE 443

WORKDIR /opt/requestbin
CMD gunicorn -b 0.0.0.0:443 --worker-class gevent --workers 2 --max-requests 1000 requestbin:app --certfile=/etc/server.crt \
--keyfile=/etc/server.key --ssl-version=3

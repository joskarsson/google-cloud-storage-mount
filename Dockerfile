FROM debian:wheezy

RUN mkdir /mnt/bucket


RUN DEBIAN_FRONTEND=noninteractive\
    apt-get update -qq &&\
    apt-get install --no-install-recommends -yqq\
    fuse\
    cron\
    rsync\
    curl &&\
    rm -rf /var/lib/apt/lists/*

ENV VERSION=0.11.1

RUN curl -sLO https://github.com/GoogleCloudPlatform/gcsfuse/releases/download/v${VERSION}/gcsfuse_v${VERSION}_linux_amd64.tar.gz &&\
    tar -oC / -zxf gcsfuse_v${VERSION}_linux_amd64.tar.gz &&\
    rm gcsfuse_v${VERSION}_linux_amd64.tar.gz &&\
    apt-get remove -yqq curl

ADD sync-logs /etc/cron.d/
RUN chmod 0744 /etc/cron.d/sync-logs

CMD ["sh", "-c", "cron && gcsfuse $BUCKET /mnt/bucket"]
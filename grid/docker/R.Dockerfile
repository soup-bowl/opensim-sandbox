FROM docker.io/library/mono:latest

RUN curl -o /bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
    && chmod +x /bin/wait-for-it

RUN apt-get update && apt-get install -y screen

RUN mkdir /opt/opensim-tmp && curl http://opensimulator.org/dist/opensim-0.9.2.0.tar.gz | tar xzf - -C /opt/opensim-tmp
RUN mkdir /opt/opensim && mv /opt/opensim-tmp/opensim*/* /opt/opensim

COPY Robust.ini /opt/opensim/bin/Robust.ini

EXPOSE 9000

WORKDIR /opt/opensim/bin

ENTRYPOINT [ "wait-for-it", "db:3306", "--", "mono",  "./Robust.exe" ]

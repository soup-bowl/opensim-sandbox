FROM docker.io/library/mono:latest

RUN apt-get update && apt-get install -y screen

RUN mkdir /opt/opensim-tmp && curl http://opensimulator.org/dist/opensim-0.9.1.1.tar.gz | tar xzf - -C /opt/opensim-tmp
RUN mkdir /opt/opensim && mv /opt/opensim-tmp/opensim*/* /opt/opensim

COPY Regions.ini          /opt/opensim/bin/Regions/Regions.ini
COPY OpenSim.ini          /opt/opensim/bin/OpenSim.ini
COPY StandaloneCommon.ini /opt/opensim/bin/config-include/StandaloneCommon.ini

EXPOSE 8002
EXPOSE 9000

WORKDIR /opt/opensim/bin

ENTRYPOINT [ "mono",  "./OpenSim.exe" ]

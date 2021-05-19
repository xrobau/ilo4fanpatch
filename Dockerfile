FROM debian:buster
LABEL maintainer xrobau@gmail.com

ARG PATCHVER

RUN apt-get update && apt-get -y install python python-pip ssh telnet vim git bsdiff

RUN pip install keystone-engine hexdump
RUN git clone https://github.com/airbus-seclab/ilo4_toolbox /usr/local/ilo4_toolbox

COPY ${PATCHVER}.patch ilo/ilo${PATCHVER}/ilo4_${PATCHVER}.bin /usr/local/
RUN bspatch /usr/local/ilo4_${PATCHVER}.bin /usr/local/ilo4_${PATCHVER}.fan.bin /usr/local/${PATCHVER}.patch

WORKDIR /usr/local


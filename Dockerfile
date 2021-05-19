FROM debian:buster
LABEL maintainer xrobau@gmail.com


RUN apt-get update && apt-get -y install python python-pip ssh telnet vim git

COPY ilo/ilo4_273.bin.fanpatch /usr/local

RUN pip install keystone-engine hexdump
RUN git clone https://github.com/airbus-seclab/ilo4_toolbox /usr/local

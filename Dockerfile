# Base image
FROM ubuntu:20.04

# Update package list
RUN apt update

RUN apt install git
RUN apt install rsync

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

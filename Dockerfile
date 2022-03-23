# Base image
FROM ubuntu:20.04

# Update package list
RUN apt update

RUN apt install git

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

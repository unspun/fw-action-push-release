# Base image
FROM ubuntu:20.04

# Update package list
RUN apt update

RUN apt install -y git

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

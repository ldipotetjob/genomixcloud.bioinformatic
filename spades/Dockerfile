FROM ubuntu:18.04

ARG SPAdesVer=3.15.3

LABEL dockerfile.version="0.0.1-b.0"
LABEL software="genomixcloud/SPAdes"
LABEL software.version="3.15.3"
LABEL website="https://github.com/ablab/spades"
LABEL license="https://github.com/ablab/spades/blob/v3.15.3/assembler/LICENSE"

# install dependencies; cleanup apt garbage
# python v2.7.12 is installed here
RUN apt-get update && apt-get install -y python \
 wget zip && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*

# install awscli
RUN wget -P /usr/src/ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -d /usr/src/  /usr/src/awscli-exe-linux-x86_64.zip && \
    rm /usr/src/awscli-exe-linux-x86_64.zip && \
    /usr/src/aws/install

# install SPAdes binary; make /data
RUN wget http://cab.spbu.ru/files/release${SPAdesVer}/SPAdes-${SPAdesVer}-Linux.tar.gz && \
  tar -xzf SPAdes-${SPAdesVer}-Linux.tar.gz && \
  rm -r SPAdes-${SPAdesVer}-Linux.tar.gz && \
  mkdir /data

COPY ./conf/ /conf/
COPY ./src/ /src/

ENV PATH="${PATH}:/SPAdes-${SPAdesVer}-Linux/bin"

WORKDIR /data

CMD ["/bin/bash", "-c"]

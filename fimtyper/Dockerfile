FROM ubuntu:20.04

ARG FimTyper="0.11.9"

LABEL software="genomixcloud/FimTyper"
LABEL software.version="0.0.1-b.0"
LABEL website="https://bitbucket.org/genomicepidemiology/fimtyper/"
LABEL license=""

RUN apt-get update && apt-get install -y build-essential git

RUN apt-get update && apt-get install -y --no-install-recommends \
 wget \
 ca-certificates \
 libmoo-perl \
 liblist-moreutils-perl \
 libjson-perl \
 gzip \
 perl \
 vim \
 curl \
 file \
 unzip \
 ncbi-blast+ && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*


# apt-get update && apt-get install -y curl

# install awscli
RUN wget -P /usr/src/ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -d /usr/src/  /usr/src/awscli-exe-linux-x86_64.zip && \
    rm /usr/src/awscli-exe-linux-x86_64.zip && \
    /usr/src/aws/install && \
    mkdir /data && mkdir /src && mkdir /conf && mkdir -p /opt/prinseq

# installing fimtyper
RUN cd /usr/local && \
	git clone --depth=1 https://bitbucket.org/genomicepidemiology/fimtyper.git && \ 
	cd /usr/local/fimtyper && \
	git clone https://bitbucket.org/genomicepidemiology/fimtyper_db.git


## COPY ./conf/* /conf/
## COPY ./src/* /src/

ENV PATH="${PATH}:/usr/local/fimtyper"

# create /data directory and set as working directory
WORKDIR /data

CMD ["/bin/bash", "-c"]
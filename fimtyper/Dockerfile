FROM ubuntu:20.04


LABEL software="genomixcloud/FimTyper"
LABEL software.version="0.0.1-a.0"
LABEL website="https://bitbucket.org/genomicepidemiology/fimtyper/"
LABEL license="https://bitbucket.org/genomicepidemiology/fimtyper/src/master/README.md#license"

RUN apt-get update && apt-get install -y build-essential git

RUN apt-get update && apt-get install -y --no-install-recommends \
 wget \
 gzip \
 libjson-perl \
 perl \
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
    mkdir /src && mkdir /conf

# installing fimtyper
RUN cd /usr/local && \
	git clone --depth=1 https://bitbucket.org/genomicepidemiology/fimtyper.git && \ 
	cd /usr/local/fimtyper && \
	git clone https://bitbucket.org/genomicepidemiology/fimtyper_db.git

COPY ./src/* /usr/local/fimtyper

RUN /usr/local/fimtyper/tmp_brew.sh

ENV PATH="${PATH}:/usr/local/fimtyper"

# create /data directory and set as working directory
WORKDIR /data

CMD ["/bin/bash", "-c"]
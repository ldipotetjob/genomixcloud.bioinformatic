FROM ubuntu:18.04

ARG FASTqcVer="0.11.9"

LABEL software="genhub/FASTqc"
LABEL software.version="0.0.1-b.0"
LABEL website="https://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
LABEL license="https://github.com/s-andrews/FastQC/blob/master/LICENSE.txt"

# install dependencies; cleanup apt garbage
RUN apt-get update && apt-get install -y \
 zip \
 wget \
 perl \
 default-jre \
 python && \
 apt-get autoclean && rm -rf /var/lib/apt/lists/*

# install awscli
RUN wget -P /usr/src/ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip -d /usr/src/  /usr/src/awscli-exe-linux-x86_64.zip && \
    rm /usr/src/awscli-exe-linux-x86_64.zip && \
    /usr/src/aws/install

# install fastqc; make /data
 RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTqcVer}.zip && \
    unzip fastqc_v${FASTqcVer}.zip && \
    rm fastqc_v${FASTqcVer}.zip && \
    chmod +x FastQC/fastqc && \
    mkdir /data && mkdir /src && mkdir /conf

COPY ./conf/* /conf/
COPY ./src/* /src/

ENV PATH="${PATH}:/FastQC/"

WORKDIR /data

CMD ["/bin/bash", "-c"]
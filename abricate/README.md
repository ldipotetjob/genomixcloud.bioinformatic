## README for abricate tool ##

This repository contains docker file to run abricate with linux docker images.

### Building abricate docker image

* move to abricate root directory(there is the docker file) 
* docker build -t  genomixcloud/abricate .

### Create a container and command(bash). @see ref. for other options running docker images 

docker run --name abricate --rm -ti genomixcloud/abricate /bin/bash

### Testing abricate installation:

```shell
docker run --name any_cool_name --rm -ti genomixcloud/abricate abricate --check
```

### Download test data

```shell
#wget 
wget https://sra-download.ncbi.nlm.nih.gov/traces/wgs03/wgs_aux/AG/QU/AGQU01/AGQU01.1.fsa_nt.gz -O contig.gz
gunzip -k < contig.gz > contig.fasta
```

```shell
#curl osx
curl -o contig.gz https://sra-download.ncbi.nlm.nih.gov/traces/wgs03/wgs_aux/AG/QU/AGQU01/AGQU01.1.fsa_nt.gz
gunzip -k < contig.gz > contig.fasta

```

### Running from local with test data

1. Change to directory where you downloaded test data or where you stored your data.
2. Create the output directory(**data_out** in our example)

```shell
docker run --name abricate --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
 genomixcloud/abricate abricate contig.fasta > $data_out/out.tab   

```

### Design Recommendations for implement and running Abricate on AWS:

**AWS S3**

**Mandatory**

In Dockerfile file:

Under comment **# install awscli** add the following code:

```shell
RUN wget -P /usr/src/ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
unzip -d /usr/src/  /usr/src/awscli-exe-linux-x86_64.zip && \
rm /usr/src/awscli-exe-linux-x86_64.zip && \
/usr/src/aws/install
```

Considerations:

1. The image contains 2 directories (/src, /conf).
2. The /src/abricate.sh can include a call to Fastqc tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder
3. With the previous configuration you can try run the commands below(to rebuild the image).

```shell 
docker build -t ${your_own_workspace}/abricate .
```

```shell
docker run --name abricate --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/abricate abricate contig.fasta > $data_out/out.tab

```

**AWS S3 + AWS ECS + AWS BATCH**

Other considerations:

1. Push the image to your AWS Account (**AWS ECR**)
2. Create an AWS BATCH job that points to the Spades image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Abricate Software](https://github.com/tseemann/abricate)
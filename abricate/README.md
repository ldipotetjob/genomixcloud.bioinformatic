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
docker run --name bakta --rm -ti genomixcloud/abricate \
--mount src="$(pwd)",target=/data,type=bind \
abricate contig.fasta > $data_out/out.tab   

```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/spades.sh, it must include a call to the Abricate tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job that points to the Spades image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Abricate Software](https://github.com/tseemann/abricate)
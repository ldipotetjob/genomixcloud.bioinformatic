## README for Spades tool ##

This repository contains docker file to run spades with linux docker image.

### Building spades docker image

* move to spades root directory(Dockerfile) 
* docker build -t genomixcloud/spades .

### Testing spades installation:

```shell
docker run --name spades-test --rm -ti genomixcloud/spades spades.py --isolate --test
```

### Download test data 

```shell
#wget 

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_1.fastq.gz -O forwardPairedReads_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_2.fastq.gz -O reversePairedReads_2.fastq.gz 
```

```shell
#curl osx

curl -o forwardPairedReads_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_1.fastq.gz 
curl -o reversePairedReads_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_2.fastq.gz 
```

### Running from local with test data 

1. Move where you download test data  
2. Create the output directory(**data_out** in our example) 

```shell
docker run --name spades --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/spades spades.py --careful \
-1 forwardPairedReads_1.fastq.gz \
-2 reversePairedReads_2.fastq.gz \
-o data_out
```

### Design recommendations for implement and running Spades on AWS:

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

Other considerations:

1. The image contains 2 directories (/src, /conf).
2. Create /src/spades.sh which can include a call to Spades tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try run the commands below.

```shell 
docker build -t ${your_own_workspace}/spades .
```

```shell
docker run --name spades --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/spades /src/spades.sh s3://fastq_forward_uri s3://fastq_reverse_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/spades.sh, it must include a call to the Spades tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**) 
4. Create an AWS BATCH job that points to the Spades image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Spades Software](https://cab.spbu.ru/software/spades/)
* [Spades Manual](https://cab.spbu.ru/files/release3.15.4/manual.html#sec2.4) 
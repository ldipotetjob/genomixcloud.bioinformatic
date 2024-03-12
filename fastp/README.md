## README for FastP tool ##

This repository contains docker file to run fastp with linux docker image.

### Building fastp docker image

* move to fastp root directory(Dockerfile)
* docker build -t genomixcloud/fastp:my_version .

### Testing fastp installation:

```shell
docker run --name fastp --rm -ti genomixcloud/fastp fastp --version
```

### Download test data

```shell
#wget 

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_1.fastq.gz -O rawreads_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_2.fastq.gz -O rawreads_2.fastq.gz 
```

```shell
#curl osx

curl -o rawreads_1.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_1.fastq.gz 
curl -o rawreads_2.fastq.gz ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR333/004/ERR3335404/ERR3335404_2.fastq.gz 
```

### Running from local with test data

1. Move where you download test data
2. Create the output directory(**data_out** in our example)

```shell
docker run --name fastp --rm -ti --mount src="$(pwd)",target=/data,type=bind \
genomixcloud/fastp:my_version fastp \
-i rawreads_1.fastq.gz \
-I rawreads_2.fastq.gz \
-o data_out/out_rawreads_1.fastq.gz \
-O data_out/out_rawreads_2.fastq.gz
```

docker run --name fastqc --rm -ti --mount src="$(pwd)",target=/data,type=bind \
genomixcloud/fastqc:my_version fastqc rawreads_1.fastq.gz rawreads_2.fastq.gz -t 4 -o ./data_out




### Design Recommendations for implement and running FastP on AWS:

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
2. The /src/fastp.sh can include a call to FastP tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder
3. With the previous configuration you can try run the commands below(to rebuild the image).

```shell 
docker build -t ${your_own_workspace}/fastp .
```

```shell
docker run --name fastp --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/fastp /src/fastp.sh s3://fastp_forward_uri s3://fastp_reverse_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

Other considerations:

1. Push the image to your AWS Account (**AWS ECR**)
2. Create an AWS BATCH job that points to the FastP image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [fastp Software](https://github.com/OpenGene/fastp)
* [fastp installer](https://github.com/OpenGene/fastp#or-download-the-latest-prebuilt-binary-for-linux-users)
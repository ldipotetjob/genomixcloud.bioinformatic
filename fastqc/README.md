## README for Fastqc tool ##

This repository contains docker file to run fastqc with linux docker images.

### Building fastqc docker image

* move to fastqc root directory(Dockerfile)
* docker build -t genomixcloud/fastqc .

### Testing fastqc installation:

```shell
docker run --name fastqc --rm -ti genomixcloud/fastqc fastqc -version
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
2. Create the outout directory(**data_out** in our example) 

```shell
docker run --name fastqc --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/fastqc fastqc \
forwardPairedReads_1.fastq.gz \
reversePairedReads_2.fastq.gz \
-o data_out
```

### Design Recommendations for implement and running Fastqc on AWS:

**AWS S3**

1. The images contain 2 directories (/src, /conf).
2. The /src/fastqc.sh can include a call to Fastqc tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder
3. With the previous configuration you can try run the commands below.

```shell 
docker build -t ${your_own_workspace}/fastqc .
```

```shell
docker run --name fastqc --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AAWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/fastqc /src/fastqc.sh s3://fastq_forward_uri s3://fastq_reverse_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contain two directories (/src, /conf).
2. IN the src directory crate /src/fastqc.sh, it must include a call to the Fastqc tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration in /conf folder
3. Push the image to your AWS Account (**AWS ECR**) 
4. Create an AWS BATCH job that points to the Fastqc image, previously uploaded  in AWS ECR. 

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  



ref:
* [Fastqc Software](https://raw.githubusercontent.com/s-andrews/FastQC/master/INSTALL.txt)
* [Fastqc main documentation](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [Fastqc Manual](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/) 
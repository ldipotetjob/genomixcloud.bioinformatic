## README for mlst tool ##

This repository contains docker file to run mlst with linux docker image.

### Building mlst docker image

* move to mlst root directory(Dockerfile)
* docker build -t genomixcloud/mlst:latest .

### Testing mlst installation:

```shell
docker run --name mlst --rm -ti genomixcloud/mlst:latest mlst --version
```

* Download **example.fna.gz** to test(**see the tree below**)  

```md
root_project
├── data
│   ├── data_fna
        └──  example.fna.gz
```

```shell
docker run --name mlst --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/mlst:latest mlst --csv \
/data/data_fna/example.fna.gz > mlst.csv
```

### Running from local with test data 

1. Move to the parent directory(**data in our example[which contain fasta files], see the tree below**)

```md
root_project
├── data
│   ├── data_fasta
│   │    └──  contigs.fasta
```

2. Run the mlst tool:

```shell
docker run --name mlst --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/mlst:latest mlst --csv --nopath --quiet --threads 2 \
/data/data_fasta/contigs.fasta > mlst.csv
```

### Design recommendations for implement and running mlst on AWS:

**AWS S3**

****Getting aws cli****

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
2. Create /src/mlst.sh which can include a call to mlst tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try run the commands below.

```shell  
docker build -t ${your_own_workspace}/mlst:your_version_tag .
```

```shell
docker run --name mlst --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/mlst /src/mlst.sh s3://data_in_fasta_uri s3://data_out_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/mlst.sh, it must include a call to the Quast tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**) 
4. Create an AWS BATCH job that points to the mlst image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Quast Software](https://github.com/ablab/mlst)
* [Quast Manual](https://mlst.sourceforge.net/docs/manual.html)

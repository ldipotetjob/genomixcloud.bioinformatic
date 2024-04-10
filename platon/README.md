## README for platon tool ##

This repository contains docker file to run platon with linux docker image.

### Building platon docker image

* move to platon root directory(Dockerfile)
* docker build -t  genomixcloud/platon:latest .

### Testing platon installation:

```shell
docker run --name platon --rm -ti genomixcloud/platon:latest platon --version
```

### Running from local with test data 

1. [Download Platon Data Base](https://github.com/oschwengers/platon?tab=readme-ov-file#database-download)
2. Move to the data input directory in this repo **data**, which contain fasta files.
3. Create the output directory(**data_out** in our example)
4. Move to the parent directory(**data in our example, see the tree above**)

```md
root_project
├── data
│   ├── data_fasta
│   │    └──contigs.fasta
│   ├── data_out
│   ├── platon_db
```

5. Run the platon tool:

```shell
docker run --name platon --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/platon:latest platon \
--mode sensitivity --threads 8 --db /data/platon_db \
/data/data_fasta/contigs.fasta -o /data/data_out
```

Remarkable aspects:

1. RAM=16Gb: **diamond execution failed! diamond-error-code=-11**, successful execution: **RAM=24Gb**  

### Design recommendations for implement and running platon on AWS:

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
2. Create /src/platon.sh which can include a call to platon tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try run the commands below.

```shell 
docker build -t ${your_own_workspace}/platon:latest .
```

```shell
docker run --name platon --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/platon /src/platon.sh s3://data_in_fasta_uri -o s3://data_out_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/platon.sh, it must include a call to the platon tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**) 
4. Create an AWS BATCH job that points to the platon image, previously uploaded in AWS ECR.

Remarkable aspects:

1. We recommend **AWS EFS for storing the Platon database in production**.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Platon Documentation](https://github.com/oschwengers/platon)

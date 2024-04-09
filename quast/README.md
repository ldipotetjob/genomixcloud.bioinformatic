## README for quast tool ##

This repository contains docker file to run quast with linux docker image.

### Building quast docker image

* move to quast root directory(Dockerfile)
* docker build --build-arg DEBIAN_FRONTEND=noninteractive -t genomixcloud/quast:latest .

### Testing quast installation:

```shell
docker run --name quast --rm -ti genomixcloud/quast:latest quast.py -h
```

### Running from local with test data 

1. Move to the data input directory in this repo **data**, which contain fasta files, fasta references and gff
2. Create the output directory(**data_out** in our example)
3. Move to the parent directory(**data in our example, see the tree above**)

```md
root_project
├── data
│   ├── data_fasta
│   │    ├── contigs_1.fasta
│   │    ├── contigs_2.fasta
│   │    ├── reference.fasta.gz
│   │ 
│   ├── data_out
│   ├── data_gff
│       └── genes.gff
```

4. Run the quast tool:

```shell
docker run --name quast --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/quast:latest quast.py \
/data/data_fasta/contigs_1.fasta /data/data_fasta/contigs_2.fasta \
-r /data/data_fasta/reference.fasta.gz -g /data/data_gff/genes.gff \
-o /data/data_out
```

### Design recommendations for implement and running quast on AWS:

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
2. Create /src/quast.sh which can include a call to quast tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try run the commands below.

```shell 
docker build --build-arg DEBIAN_FRONTEND=noninteractive -t ${your_own_workspace}/quast:your_version_tag . 
```

```shell
docker run --name quast --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/quast /src/quast.sh s3://data_in_fasta_uri -o s3://data_out_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/quast.sh, it must include a call to the Quast tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**) 
4. Create an AWS BATCH job that points to the quast image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Quast Software](https://github.com/ablab/quast)
* [Quast Manual](https://quast.sourceforge.net/docs/manual.html) 
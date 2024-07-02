## README for Prokka tool ##

This repository contains docker file to run prokka with linux docker image.

### Building prokka docker image

* move to prokka root directory(Dockerfile)
* docker build --build-arg DEBIAN_FRONTEND=noninteractive -t genomixcloud/prokka:your_version .

### Testing prokka installation:

```shell
docker run --name prokka --rm genomixcloud/prokka:1.14.6 prokka --version
```

### Running from local with test data

1. Move to the parent directory(**data in our example[which contain fasta files], see the tree below**)

```md
root_project
├── data
│   ├── data_fasta
│   │    └──  contigs.fasta
```

2. Run the prokka tool:

```shell
docker run --name prokka --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/prokka prokka contig.fasta --cpu 4 --force
```

### Design recommendations for implement and running prokka on AWS:

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
2. Create /src/prokka.sh which can include a call to prokka tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try to run the commands below.

```shell  
docker build --build-arg DEBIAN_FRONTEND=noninteractive -t ${your_own_workspace}/prokka:your_version_tag
```

```shell
docker run --name prokka --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/prokka /src/prokka.sh s3://data_in_fasta_uri s3://data_out_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/prokka.sh, it must include a call to the Spades tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job that points to the prokka image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Prokka Software](https://github.com/tseemann/prokka)





































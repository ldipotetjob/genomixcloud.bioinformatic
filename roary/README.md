## README for Roary tool ##

This repository contains docker file to run roary with linux docker image.

### Building roary docker image

* move to roary root directory(Dockerfile)
* docker build --build-arg DEBIAN_FRONTEND=noninteractive -t genomixcloud/roary:latest .

### Testing roary installation:

We test **roary**, **fasttree**, **roary2svg**:

```shell
docker run --name roary --rm -ti genomixcloud/roary:latest /src/roary.sh -w
docker run --name roary --rm -ti genomixcloud/roary:latest /src/roary.sh --help
docker run --name roary2svg --rm -ti genomixcloud/roary:latest /src/roary2svg.sh --help
docker run --name fasttree --rm -ti genomixcloud/roary:latest /src/fasttree.sh --help
```

### Running from local with test data

* Move to the data input directory in this repo(**data/data_gff, see the tree below**), which contain gff files 

```md
root_project
├── data
    ├── data_gff
        ├── PROKKA_v1.gff
        ├── PROKKA_v2.gff
        └── PROKKA_v3.gff
```

1. Run the scripts below following the order:

1.1:
```shell
docker run --name roary --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/roary:latest /src/roary.sh -e --mafft -p 8 *.gff -f pangenome
```

1.2:
```shell
docker run --name roary --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/roary:latest /src/fasttree.sh -nt \
-gtr pangenome/core_gene_alignment.aln > pangenome/core_gene_alignment.newick
```

### Design recommendations for implement and running Roary on AWS:

**AWS S3**

**Getting aws cli**

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
2. Create /src/roary.sh, it must include a call to the following tools: roary tool and fasttree(check the order above), the **in** and **out** directories are linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder.
3. With the previous configuration you can try run the commands below.

```shell 
docker build --build-arg DEBIAN_FRONTEND=noninteractive -t ${your_own_workspace}/roary:your_version_tag .
```

```shell
docker run --name roary --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/roary /src/roary.sh s3://fasta_uri s3://fastq_forward_uri s3://fastq_reverse_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/roary.sh, it must include a call to the following tools: bwa-mem2, samtools and roary tool(check the order above), the **in** and **out** directories are linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job that points to the Roary image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Roary Software](https://github.com/sanger-pathogens/Roary/)
* [source data to generate roary input data](https://github.com/microgenomics/tutorials/blob/master/pangenome.md)
## README for Pilon tool ##

This repository contains docker file to run pilon with linux docker image.

### Building pilon docker image

* move to pilon root directory(Dockerfile)
* docker build -t genomixcloud/pilon:my_version .

### Testing pilon installation:

We test **bwa-mem2** and **samtools**: 
Input to Pilon consists of the input genome in FASTA format along with one or more BAM files \
of reads aligned to the input genome.

```shell
docker run --name pilon --rm -ti genomixcloud/pilon:latest bash pilon --help
docker run --name bwa-mem2 --rm -ti genomixcloud/pilon:latest bwa-mem2 version
docker run --name samtools --rm -ti genomixcloud/pilon:latest samtools --help
```

### Running from local with test data

1. Move to the data input directory in this repo **data**, which contain trimmed sample reads and fasta file
2. Create the output directory(**data_out** in our example)
3. Move to the parent directory(**data in our example, see the tree below**)

```md
root_project
├── data
│   ├── data_fasta
│   │    └── contigs.fasta
│   ├── data_out
│   ├── data_in_trimmed
│       ├── trimmed_reads_1.fastq.gz
│       ├── trimmed_reads_2.fastq.gz
```

4. Run the scripts below following the order: 

1:
```shell
docker run --name bwa-mem2 --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/pilon:latest bwa-mem2 mem -t 4 -P -S -Y -M \
-o /data/data_out/sample.sam \
/data/data_fasta/contigs.fasta \
/data/data_in_trimmed/trimmed_reads_1.fastq.gz /data/data_in_trimmed/trimmed_reads_2.fastq.gz
```

2:
```shell
docker run --name samtools-view --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/pilon:latest samtools view -Sb /data/data_out/sample.sam \
-o /data/data_out/sample.bam -t 8
```

3:
```shell
docker run --name samtools-sort --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/pilon:latest samtools sort /data/data_out/sample.bam \
-o /data/data_out/sample.sort.bam
```

4:
```shell
docker run --name samtools-index --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/pilon:latest samtools index /data/data_out/sample.sort.bam
```

5:
```shell
docker run --name pilon --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/pilon:latest pilon ---genome /data/data_fasta/contigs.fasta \
--bam /data/data_out/sample.sort.bam \
--outdir /data/data_out/ --output assembly.polish --threads 8 --minqual 30 --nostrays
```

### Design recommendations for implement and running Pilon on AWS:

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

docker run --name bwa-mem2 --rm -ti genomixcloud/pilon:latest bwa-mem2 version
docker run --name bwa-mem2 and samtools --rm -ti genomixcloud/pilon:latest samtools --help



Other considerations:

1. The image contains 2 directories (/src, /conf).
2. Create /src/pilon.sh w, it must include a call to the following tools: bwa-mem2, samtools and pilon tool(check the order above), the **in** and **out** directories are linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder.
3. With the previous configuration you can try run the commands below.

```shell 
docker build -t ${your_own_workspace}/pilon:your_version_tag .
```

```shell
docker run --name pilon --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/pilon /src/pilon.sh s3://fasta_uri s3://fastq_forward_uri s3://fastq_reverse_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/pilon.sh, it must include a call to the following tools: bwa-mem2, samtools and pilon tool(check the order above), the **in** and **out** directories are linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job that points to the Pilon image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Pilon Software](https://github.com/broadinstitute/pilon)
* [Pilon Manual](https://github.com/broadinstitute/pilon/wiki) 

## README for kraken tool ##

This repository contains docker file to run kraken2 with linux docker image.

### Building kraken2 docker image

* move to kraken2 root directory(Dockerfile)
* docker build -t genomixcloud/kraken2:my_version .

### Testing kraken2 installation:

```shell
docker run --name kraken2 --rm -ti genomixcloud/kraken2:latest kraken2 -version

 # blastn+ 2.0.9
docker run --name blastn --rm -ti genomixcloud/kraken2:latest blastn -version

# kraken-build
docker run --name kraken2-build --rm -ti genomixcloud/kraken2:latest  kraken2-build --help
```

### Running from local with test data

1. Download kraken2 db db to **kraken_db** directory (for local test: [download mini-krakenDB](https://genome-idx.s3.amazonaws.com/kraken/minikraken2_v2_8GB_201904.tgz) )
2. Move to the data input directory in this repo **data**, which contain trimmed sample reads and kraken db
3. **Create** the output directory(**data_out/taxonomic_identification** in our example)
4. Move to the parent directory(**data in our example, see the tree below**)

```md
root_project
├── data
│   ├── kraken_db 
│   ├── data_out
│   │   └── taxonomic_identification
│   ├── data_in_trimmed
│       ├── trimmed_reads_1.fastq.gz
│       ├── trimmed_reads_2.fastq.gz
```

5. Run kraken2 tool:

A remarkable aspect: **--memory-mapping** attribute is **mandatory** when running in this configuration

```shell
docker run --name kraken2 --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/kraken2:latest kraken2  --paired \
/data/data_in_trimmed/trimmed_reads_1.fastq.gz /data/data_in_trimmed/trimmed_reads_2.fastq.gz \
--db /data/kraken_db --threads 8 --memory-mapping --report /data/data_out/taxonomic_identification/kraken-report.txt
```

### Design recommendations for implement and running Kraken on AWS:

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
2. Create /src/kraken2.sh which can include a call to kraken2 tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try run the commands below.

```shell 
docker build -t ${your_own_workspace}/kraken2:your_version_tag .
```

```shell
docker run --name kraken2 --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/kraken2:latest kraken2  --paired \
s3://fastq_forward_uri s3://fastq_reverse_uri --db /data/kraken_db \
--threads 8 --memory-mapping --report s3://taxonomic_identification_uri/kraken-report.txt
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/kraken2.sh, it must include a call to the Spades tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job that points to the Spades image, previously uploaded in AWS ECR.

Remarkable aspects: 

1. We don't recommend [--memory-mapping in production environment](https://github.com/ldipotetjob/kraken2/blob/kraken2aws_profilingfromv2.1.3/docs/Kraken2paramsonAWS/memory-mapping.md#memory-mapping-option).  
2. [How to create Kraken2 Standard(v2.1.3) DB in AWS](https://github.com/ldipotetjob/kraken2/tree/kraken2aws_profilingfromv2.1.3/docs/awsStandardDB#readme)
3. [Profiling info](https://github.com/ldipotetjob/kraken2/tree/kraken2aws_profilingfromv2.1.3/docs/awsStandardDB/profilingpngs)
4. We recommend AWS EFS for storing the Kraken2 Standard (v2.1.3) database in production.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [kraken Software](https://github.com/DerrickWood/kraken2)
* [kraken Manual](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown) 
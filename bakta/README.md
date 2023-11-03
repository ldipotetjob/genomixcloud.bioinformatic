## README for Bakta tool ##

This repository contains docker file to run bakta with linux docker image.

### Building bakta docker image

* move to bakta root directory(Dockerfile)
* docker build -t genomixcloud/bakta .

### Testing bakta installation:

```shell
docker run --name bakta --rm -ti genomixcloud/bakta /src/bakta.sh --version
```

### Download test data 

```shell
#wget 
wget https://sra-download.ncbi.nlm.nih.gov/traces/wgs03/wgs_aux/AG/QU/AGQU01/AGQU01.1.fsa_nt.gz -O contig.gz
gunzip contig.gz
```

```shell
#curl osx
curl -o contig.gz https://sra-download.ncbi.nlm.nih.gov/traces/wgs03/wgs_aux/AG/QU/AGQU01/AGQU01.1.fsa_nt.gz
gunzip contig.gz

```

### Download the mandatory Bakta database 

**Hint:**</br>

The compressed size of the Bakta **full database type** > 30GB(**uncompressed is around 64GB**), running in docker you can create 
the database in external storage
* change directory to your external storage and run the following commands 

```shell

docker run --name bakta --rm -ti --mount src="$(pwd)",target=/data,type=bind genomixcloud/bakta bash
## Inside the container /data is our workdir but you can specify a detailed path in your your external storage
bakta_db download --output /data  --type full

```

ref: [bakta database download](https://github.com/oschwengers/bakta/blob/main/README.md#database-download)


### Running from local with test data 

1. Change to directory where you downloaded test data or where you stored your data.  
2. Create the output directory(**data_out** in our example) 

```shell
docker run --name bakta --rm -ti genomixcloud/bakta \
--mount src="$(pwd)",target=/data,type=bind \
/src/bakta.sh contig.fasta --output data_out 

```

### Design Recommendations for implement and running Bakta on AWS:

**AWS S3**
1. The image contains 2 directories (/src, /conf).
2. The /src/bakta.sh can include a call to bakta tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder
3. With the previous configuration you can try run the commands below.

**AWS EFS**
1. The full bakta db(around 64GB) should be stored in a volume on AWS EFS so the **bakta.sh call** must include a path to DB, linked to a volume on AWS EFS.

**AWS S3 + AWS ECS + AWS EFS + AWS BATCH**

1. Our image contain two directories (/src, /conf).
2. In the src directory create /src/bakta.sh, it must include a call to the bakta tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration in /conf folder
3. In /src/bakta.sh, bakta_db path can be linked to a Volume on AWS EFS. The previous link can be configured in /conf folder.
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job(must be linked to a Volume on AWS EFS) that points to the Bakta image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch, AWS EFS  

ref:
* [Bakta Software](https://github.com/oschwengers/bakta/blob/main/README.md#installation)
* [Bakta Manual](https://github.com/oschwengers/bakta/blob/main/README.md) 
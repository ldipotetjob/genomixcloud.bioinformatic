## README for Checkm tool ##

This repository contains docker file to run checkm with linux docker image.

### Building checkm docker image

* move to checkm root directory(Dockerfile)
* docker build -t genomixcloud/checkm:my_version .

### Testing checkm installation:
1. Download checkm db to **checkm_db** directory 
2. Move to the parent directory(**data in our example, see the tree above**)

```md
root_project
├── data
│   ├── checkm_db
```

3. Run the checkM tool:

```shell
docker run --name checkm --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/checkm:latest checkm taxonomy_wf species "Escherichia coli" \
/data/checkm_db/test_data/ /data/checkm_test_results
```

### Running from local with test data

1. Move to the data input directory data/data_fasta
2. Create the output directory(**data_out** in our example)

```shell
docker run --name checkm --rm -ti \
--mount src="$(pwd)",target=/data/,type=bind \
genomixcloud/checkm:latest checkm taxonomy_wf life \
Prokaryote ./data/data_fasta -x fasta ./data/data_out
```

### Can be called like the previous docker implementation the following checkM utilities(follow the order):  
1. checkm tree /data/data_fasta/ -x fasta /data/data_out --reduced_tree --threads 8
2. checkm tree_qa -o 2 /data/data_out
3. checkm gc_plot /data/data_out/bins /data/data_out/plots 95

### Design recommendations for implement and running CheckM on AWS:

**AWS S3**

Other considerations:

1. The image contains 2 directories (/src, /conf).
2. Create /src/checkm.sh which can include a call to checkm tool and **data_in** and **data_out** directories linked to AWS S3. The previous link can be configured in /conf folder.
3. With the previous configuration you can try run the commands below.

```shell
docker run --name checkm --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data/,type=bind \
genomixcloud/checkm:latest /src/checkm.sh taxonomy_wf life \
Prokaryote s3://data_in_fasta_uri -x fasta s3://data_out_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. Our image contains two directories (/src, /conf).
2. In the src directory create /src/checkm.sh, it must include a call to the Spades tool and the **in** and **out** directories linked with AWS S3. You can place the S3 configuration and any parameter needed for the tool in the /conf folder
3. Push the image to your AWS Account (**AWS ECR**)
4. Create an AWS BATCH job that points to the Spades image, previously uploaded in AWS ECR.

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [CheckM Software](https://github.com/Ecogenomics/CheckM)
* [CheckM Manual](https://ecogenomics.github.io/CheckM/) 

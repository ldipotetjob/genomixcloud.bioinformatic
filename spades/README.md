## README for Spades tool ##

This repository contains docker file to run spades with linux docker images.

### Building spades docker image

* move to spades root directory(there is the docker file) 
* docker build -t genomixcloud/spades

### Testing spades installation:

```shell
docker run --name spades-test --rm -ti genomixcloud/spades spades.py --isolate --test
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
docker run --name spades --rm -ti \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/spades spades.py --careful \
-1 forwardPairedReads_1.fastq.gz \
-2 reversePairedReads_2.fastq.gz \
-o data_out
```

### Design recomendations  runnning spades on AWS environmemnts:

```shell
docker run --name spades --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AAWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
genomixcloud/spades /src/spades.sh
```



ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Spades Software](https://cab.spbu.ru/software/spades/)
* [Spades Manual](https://cab.spbu.ru/files/release3.15.4/manual.html#sec2.4) 

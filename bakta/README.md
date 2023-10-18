## README for Bakta tool ##

This repository contains docker file to run fastqc with linux docker image.

### Building bakta docker image

* move to bakta root directory(Dockerfile)
* docker build -t genomixcloud/bakta .

### Testing bakta installation:

```shell
docker run --name bakta --rm -ti genomixcloud/bakta /src/baktatest.sh --version
```

### Download test data 

```shell
#wget 


```

```shell
#curl osx


```

### Running from local with test data 

1. Move where you download test data  
2. Create the output directory(**data_out** in our example) 

```shell


```

### Design Recommendations for implement and running Fastqc on AWS:

**AWS S3**



**AWS S3 + AWS ECS + AWS BATCH**


In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  

ref:
* [Bakta Software](https://github.com/oschwengers/bakta/blob/main/README.md#installation)
* [Bakta Manual](https://github.com/oschwengers/bakta/blob/main/README.md) 
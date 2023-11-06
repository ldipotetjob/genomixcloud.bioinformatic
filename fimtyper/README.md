## README for FimTyper tool ##

This repository contains docker file to run FimTyper with linux docker image.

### Building FimTyper docker image

* move to FimTyper root directory(Dockerfile)
* docker build -t genomixcloud/fimtyper .

### Testing fimtyper installation:

```shell
 docker run --name fimtyper --rm -ti genomixcloud/fimtyper \
 perl /usr/local/fimtyper/fimtyper.pl
```

### Running from local with test data 
ref: https://bitbucket.org/genomicepidemiology/fimtyper/src/master/README.md#usage

```shell
 docker run --name fimtyper --rm -ti genomixcloud/fimtyper \
 perl /usr/local/fimtyper/fimtyper.pl \
 -d /usr/local/fimtyper/fimtyper_db -i \
 /usr/local/fimtyper/test.fsa -k 95.00 -l 0.60
```

### Design recommendations for implement and running FimTyper on AWS:

**AWS S3**

**Mandatory**

In Dockerfile file:

Under comment **# install awscli** add the following code:

```shell
RUN wget -P /usr/src/ https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
unzip -d /usr/src/  /usr/src/awscli-exe-linux-x86_64.zip && \
rm /usr/src/awscli-exe-linux-x86_64.zip && \
/usr/src/aws/install && \
mkdir /src && mkdir /conf
```

Other considerations:

1. The image contains 2 directories (/src, /conf).
2. The /src/fimtyper.sh can include a call to FimTyper tool and **in** and **out** directories linked with AWS S3. The previous link can be configured in /conf folder
3. With the previous configuration you can try run the commands below.

```shell 
docker build -t ${your_own_workspace}/fimtyper .
```

```shell
docker run --name fimtyper --rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
--mount src="$(pwd)",target=/data,type=bind \
${your_own_workspace}/fimtyper /src/fimtyper.sh s3://fas_file_uri
```

**AWS S3 + AWS ECS + AWS BATCH**

1. In the src directory create /src/fimtyper.sh, it must include a call to the /usr/local/fimtyper/fimtyper.pl tool and the **input** directory linked with AWS S3. You can place the S3 configuration and the parameters for the FimTyper tool in /conf folder. 
2. Push the image to your AWS Account (**AWS ECR**) 
3. Create an AWS BATCH job that points to the FimTyper image, previously uploaded in AWS ECR. 

In this implementation, we just pointed to the core aspect. Be aware that a first glance, you will need to configure AWS services like AWS Networking, AWS IAM, AWS S3, AWS Batch  



ref:
* [FimTyper main documentation](https://bitbucket.org/genomicepidemiology/fimtyper/)

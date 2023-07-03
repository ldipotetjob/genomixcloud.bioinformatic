## README for Spades tool ##

This repository contains docker file to run spades with linux docker images.

### Building spades docker image

* move to spades root directory(there is the docker file) 
* docker build -t genomixcloud/spades

### Create a container and command(bash). @see ref. for other options running docker images 

docker run --name spades-test --rm -ti genomixcloud/spades /bin/bash

### Testing spades installation:

```shell
spades.py --isolate --test
```

### Example launch tool spades with sample reads:

```shell
docker run --name spades \
--rm -ti \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AAWS_SECRET_ACCESS_KEY}" \
genhub/spades:18.04 /src/spades.sh
```

ref:
* [Docker run command](https://docs.docker.com/engine/reference/commandline/run/)
* [Spades Software](https://cab.spbu.ru/software/spades/)
* [Spades Manual](https://cab.spbu.ru/files/release3.15.4/manual.html#sec2.4) 

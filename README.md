# Druid Docker image

### Quickly run druid

* Install Docker 
* Run the docker image


```
sudo docker run -p 8081:8081 -p 8082:8082 -p 8083:8083 -p 8090:8090 -v <host_path>:<container_path> druid-docker
```
For example:

```
sudo docker run -p 8081:8081 -p 8082:8082 -p 8083:8083 -p 8090:8090 -v /home/docker-user/tpch:/mnt/tpch druid-docker
```

### Ports 

8081 - coordinator

8082 - broker

8083 - historical

8090 - overlord

### Indexing using docker image

When submitting a task to the indexing service, please ensure that the path mounted above is same as in the index spec submmited to the indexing service.

For example, if the docker mount point is /mnt/tpch, the file to be indexed is part-00000, then the json spec will look like below:

```
...
"ioConfig": {
      "type": "index",
      "firehose": {
        "type": "local",
        "baseDir": "/mnt/tpch/",
        "filter": "part-00000"
      }
    },
...

```


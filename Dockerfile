FROM ubuntu:14.04
RUN apt-get update && apt-get install -y --force-yes wget  && apt-get install -y --force-yes axel

RUN apt-get install -y software-properties-common \
	&& apt-add-repository -y ppa:webupd8team/java \
	&& apt-get purge --auto-remove -y software-properties-common \
	&& apt-get update \
	&& echo oracle-java-8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& apt-get install -y oracle-java8-installer \
	&& apt-get install -y oracle-java8-set-default \
	&& rm -rf /var/cache/oracle-jdk8-installer

RUN apt-get install -y supervisor

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Zookeeper
RUN  wget -q -O - http://www.us.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xzvf - -C /usr/local \
&& cp /usr/local/zookeeper-3.4.6/conf/zoo_sample.cfg /usr/local/zookeeper-3.4.6/conf/zoo.cfg

WORKDIR /usr/local/zookeeper

# Setup supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Druid (release tarball)
ENV DRUID_VERSION 0.8.3
RUN axel -n10  http://static.druid.io/artifacts/releases/druid-$DRUID_VERSION-bin.tar.gz \
&& tar -xzvf druid-$DRUID_VERSION-bin.tar.gz -C /usr/local

WORKDIR /usr/local/druid-0.8.3


EXPOSE 8081
EXPOSE 8082
EXPOSE 8083
EXPOSE 8090
EXPOSE 2181

ENTRYPOINT exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
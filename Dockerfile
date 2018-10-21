FROM ubuntu:16.04
MAINTAINER xj.yan@foxmail.com
ENV REFRESHED_AT 2018-10-21
ENV DEBIAN_FRONTEND=noninteractive

## install apps
RUN \
  apt-get update && \
  apt-get install -y sudo vim iputils-ping wget curl apt-transport-https software-properties-common python-software-properties git

## install java 8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN java -version

## Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["bash"]

# general dependencies
RUN apt-get update -qq && apt-get install -qqy apt-transport-https iptables ca-certificates git-core curl software-properties-common

# install docker
RUN curl https://get.docker.com/gpg | apt-key add -
RUN echo deb http://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update -qq && apt-get install -qqy  lxc lxc-docker

# install docker compose
ENV COMPOSE_VERSION 1.4.0

RUN curl -L https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# install jenkins
ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org

RUN mkdir -p $JENKINS_HOME/plugins
RUN curl -sf -o /opt/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/latest/jenkins.war

# jenkins plugins
RUN for plugin in greenballs scm-api git-client git ws-cleanup ;\
    do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi \
       -L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi ; done


ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org


RUN mkdir -p $JENKINS_HOME/plugins
RUN curl -sf -o /opt/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/\
latest/jenkins.war


RUN for plugin in chucknorris greenballs scm-api git-client git\
  ws-cleanup ;\
    do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi \
      -L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi\
        ; done

COPY scripts/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

VOLUME /var/lib/docker

EXPOSE 8080

ENTRYPOINT [ "/usr/local/bin/dockerjenkins.sh" ]
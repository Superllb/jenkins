FROM yanxinjie/java8
MAINTAINER xj.yan@foxmail.com
ENV REFRESHED_AT 2018-10-21

# general dependencies
RUN apt-get update -qq && apt-get install -qqy apt-transport-https iptables ca-certificates git-core curl software-properties-common

# install docker
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
RUN echo 'deb http://cz.archive.ubuntu.com/ubuntu trusty main' | sudo tee /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -qqy docker-engine

# install docker compose
ENV COMPOSE_VERSION 1.4.0
RUN curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

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
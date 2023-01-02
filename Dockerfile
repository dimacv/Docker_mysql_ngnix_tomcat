# имидж основанный на Ubuntu 22.04 и позволяющий запускать много сервисов
#FROM  phusion/baseimage:jammy-1.0.1
FROM  mysql:5.7-debian

SHELL ["/bin/bash", "-c"]
ENV HOME=/home/ubuntu \
    DEBIAN_FRONTEND=noninteractive

ENV JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
ENV CATALINA_PID=/opt/tomcat/temp/tomcat.pid
ENV CATALINA_HOME=/opt/tomcat
ENV CATALINA_BASE=/opt/tomcat
ENV CATALINA_OPTS="-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ENV JAVA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ENV PATH=$CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME


# установка необходимого софта
RUN apt update && apt upgrade -y
RUN apt install -q -y mc htop nginx zip unzip sudo sudo default-jre curl

RUN adduser --system --disabled-password --home ${HOME} --shell /bin/bash --group --uid 1000 ubuntu
# для правильной работы nginx-сервера нужно дописать строку "ubuntu:x:1000:www-data" в файл /etc/group
RUN echo "ubuntu:x:1000:www-data" >> /etc/group

RUN mkdir /data && chmod 777 /data


RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

COPY files/apache-tomcat-9.0.70.tar.gz /tmp/

RUN cd /tmp && \
    #curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz && \
    #mkdir /opt/tomcat && \
    tar xzvf apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1 && \
    cd /opt/tomcat && \
    chgrp -R tomcat /opt/tomcat && \
    chmod -R g+r conf && \
    chmod g+x conf && \
    chmod -R g+r conf && \
    chmod g+x conf && \
    chown -R tomcat webapps/ work/ temp/ logs/
    #&& \
    #update-java-alternatives -l

WORKDIR /opt/tomcat/webapps
#RUN curl -O -L https://github.com/bhaskarndas/sample-war/raw/main/sampletest.war
#RUN curl -O -L https://github.com/softwareyoga/docker-tomcat-tutorial/blob/master/sample.war
RUN curl -O -L https://github.com/AKSarav/SampleWebApp/raw/master/dist/SampleWebApp.war


COPY files/run.sh run.sh
RUN chmod +x run.sh

#RUN apt-get install -y python3 python3-pip


RUN apt-get -y install openssh-server supervisor
RUN mkdir /var/run/sshd; chmod 755 /var/run/sshd
RUN mkdir /root/.ssh; chown root. /root/.ssh; chmod 700 /root/.ssh
RUN ssh-keygen -A

# Очистить APT.
RUN apt-get clean && apt autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_* /usr/share/man/??.*

EXPOSE 8080
#CMD ["/opt/tomcat/bin/startup.sh", "run"]
#CMD /opt/tomcat/bin/startup.sh run
CMD bash


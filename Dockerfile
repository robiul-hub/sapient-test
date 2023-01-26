FROM ubuntu:18.04
WORKDIR /opt/java
ADD openjdk-12.0.1_linux-x64_bin.tar.gz .
ENV JAVA_HOME /opt/java/jdk-12.0.1
ENV PATH $PATH:$JAVA_HOME/bin
WORKDIR /opt/tomcat
ADD apache-tomcat-9.0.52.tar.gz .
COPY PStore.war /opt/tomcat/apache-tomcat-9.0.52/webapps
EXPOSE 8080
CMD ["/opt/tomcat/apache-tomcat-9.0.52/bin/catalina.sh", "run"]

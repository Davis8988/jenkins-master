FROM jenkins/jenkins:2.194-slim

# define JVM options
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER jenkins

# install jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy jenkins jobs
COPY jobs-configs/1-github-seed-job.xml           /usr/share/jenkins/ref/jobs/1-github-seed-job/config.xml

# copy jenkins configuration
COPY conf/init.groovy.d /usr/share/jenkins/ref/init.groovy.d
COPY seeds/jobs  /usr/share/jenkins/ref/jobs
COPY seeds/views /usr/share/jenkins/ref/views

# SSH Keys & Credentials
COPY conf/credentials/credentials.xml      /usr/share/jenkins/ref/credentials.xml
COPY conf/credentials/ssh-keys/cd-demo     /usr/share/jenkins/ref/.ssh/id_rsa
COPY conf/credentials/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub
# This dockerfile configures jenkins master image
FROM artifactory.esl.corp.elbit.co.il/aerospace-simulators-devops-docker/jenkins/master:2.213-centos7

LABEL Description="This image is for running jenkins master server as a container"
LABEL maintainer="yair.david@elbitsystems.com"

#  ARG httpProxy
#  ARG noProxy


# Set JENKINS_UC to artifactory to enable download of plugins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false" 
# ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"  \
    # JENKINS_UC="http://artifactory.esl.corp.elbit.co.il/artifactory/jenkins_update/current/update-center.json" \
    # JENKINS_UC_DOWNLOAD="http://updates.jenkins-ci.org/download"
    # HTTPS_PROXY=${httpProxy} \
    # https_proxy=${httpProxy} \
    # HTTP_PROXY=${httpProxy} \
    # http_proxy=${httpProxy} \
    # ftp_proxy=${httpProxy} \
    # FTP_PROXY=${httpProxy} \
    # NO_PROXY=${noProxy} \
    # no_proxy=${noProxy}


# Copy plugins.txt file:
COPY expanding_image/jenkins_plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins from .hpi files
COPY --chown=jenkins:jenkins expanding_image/jenkins_plugins/offline-plugins-files/ /usr/share/jenkins/ref/plugins/

# Install Plugins using script: /usr/local/bin/install-plugins.sh
#   When building use flag: --add-host 
#    exmaple: docker build -t nteptartifact:5014/jenkins:configured --add-host=nteptartifact:10.0.50.49 --add-host=updates.jenkins-ci.org:10.0.50.49 .
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt


# Copy files needed in the container
COPY expanding_image/init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/
# COPY expanding_image/seed-job/ /usr/share/jenkins/ref/jobs/seed-job
COPY expanding_image/scriptApproval.xml.override /usr/share/jenkins/ref/scriptApproval.xml.override
# COPY expanding_image/compute-seed-job-hash.sh /tmp/


# Must switch to root in order to update /etc/hosts file
# USER root
# Add nteptartifact and updates.jenkins-ci.org (10.0.50.49)
# RUN echo 10.0.50.49   nteptartifact >> /etc/hosts; echo 10.0.50.49   updates.jenkins-ci.org >> /etc/hosts


# Pre-approve the seed job
# RUN /tmp/compute-seed-job-hash.sh /usr/share/jenkins/ref/jobs/seed-job/workspace/job.groovy.override /usr/share/jenkins/ref/scriptApproval.xml.override


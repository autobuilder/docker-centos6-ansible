FROM centos:6
LABEL maintainer="AutoBuilder24x7"
ENV container=docker

ENV pip_packages "ansible"

# Install requirements.
RUN yum makecache fast \
 && yum -y install initscripts \
 && yum -y update \
 && yum -y install \
      python-pip \
      ansible \
      sudo \
      which \
      initscripts \
      python-urllib3 \
      pyOpenSSL \
      python2-ndg_httpsclient \
      python-pyasn1 \
 && yum clean all

# Install Ansible via Pip.
RUN pip install $pip_packages

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts
RUN ansible --version

CMD ["/sbin/init"]
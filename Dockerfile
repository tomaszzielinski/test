FROM phusion/baseimage

ENV HOME /root
CMD ["/sbin/my_init","--enable-insecure-key"]

# https://github.com/phusion/baseimage-docker/issues/58
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y python-dev python-setuptools python-apt gcc git-core && easy_install pip
RUN git clone https://github.com/appsembler/configuration.git -b docker_release /configuration
RUN pip install -r configuration/requirements.txt

WORKDIR /configuration/playbooks

RUN /usr/sbin/runsvdir-start & ansible-playbook -vv -c local -i "127.0.0.1," docker_lite.yml

EXPOSE 80 18010 18020

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

FROM centos:centos7
MAINTAINER jspc <james.condron@ft.com>

ADD src/mongo.repo /etc/yum.repos.d/mongo.repo

RUN yum install -y mysql mongodb-org-shell

COPY src/ db/
ENTRYPOINT ["/db/entrypoint.sh"]

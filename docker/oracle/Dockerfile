FROM centos:7
MAINTAINER Devan Goodwin <dgoodwin@redhat.com>

# Configure oracle:
# TODO: move this to script later:

# This is a bit slow and expensive so we'll do it as a separate
# layer so the setup script can be tweaked quicker:
#RUN wget --no-verbose -r --reject 'index.html*' --no-parent -l 1 http://file.rdu.redhat.com/~dgoodwin/oracle/ -nH -nd -P /root/oracle/
ADD http://auto-services.usersys.redhat.com/rhsm/oracle-11.2.0.4.0-1.tar.gz /root/oracle/
RUN tar -xvf /root/oracle/oracle-11.2.0.4.0-1.tar.gz -C /root/oracle/ && rm -f /root/oracle/oracle-11.2.0.4.0-1.tar.gz
COPY setup-supervisord.sh /root/
COPY setup-oracle-buildtime.sh /root/
COPY setup-oracle-runtime.sh /root/
COPY xe.rsp /root/
COPY launch-oracle.sh /usr/bin/
RUN yum install -y epel-release
RUN /bin/bash /root/setup-supervisord.sh
RUN /bin/bash /root/setup-oracle-buildtime.sh

EXPOSE 8090
EXPOSE 1521

CMD ["/usr/bin/launch-oracle"]

FROM centos:7
#MAINTAINER Devan Goodwin <dgoodwin@redhat.com>
MAINTAINER Chris Rog <crog@redhat.com>

ENV LANG en_US.UTF-8

# Copy just enough to get the deps installed, doing it this way (instead of git cloning the whole thing)
# so that the docker layers can be cached, and thus speed up build times.
RUN /usr/bin/mkdir /root/candlepin-deps
ADD https://raw.githubusercontent.com/candlepin/candlepin/master/Gemfile /root/candlepin-deps/Gemfile
ADD https://raw.githubusercontent.com/candlepin/candlepin/master/Gemfile.lock /root/candlepin-deps/Gemfile.lock
ADD https://raw.githubusercontent.com/candlepin/candlepin/master/buildfile /root/candlepin-deps/buildfile

COPY setup-devel-env.sh /root/
RUN /bin/bash /root/setup-devel-env.sh

# Need a wrapper script to get proper start/stop behaviour with supervisord:
COPY setup-supervisord.sh /root/
RUN /bin/bash /root/setup-supervisord.sh

# Script for actually running the tests, could theoretically move to candlepin
# checkout for easier updating.
COPY setup-db.sh /root/
COPY cp-test /usr/bin/
COPY setup-db.sh /root/

EXPOSE 8443 22

#CMD ["/usr/bin/cp-test", "-t", "-u", "-r"]
CMD ["true"]

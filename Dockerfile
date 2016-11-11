FROM fedora
MAINTAINER VCA Technology <developers@vcatechnology.com>

# Update all packages
RUN dnf -y update && \
  dnf clean all --enablerepo=\*

# Generate locales
RUN cat /etc/locale.gen | expand | sed 's/^# .*$//g' | sed 's/^#$//g' | egrep -v '^$' | sed 's/^#//g' > /tmp/locale.gen \
  && mv -f /tmp/locale.gen /etc/locale.gen \
  && locale-gen
ENV LANG=en_GB.utf8

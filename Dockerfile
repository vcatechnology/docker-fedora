FROM fedora
MAINTAINER VCA Technology <developers@vcatechnology.com>

# Build-time metadata as defined at http://label-schema.org
ARG PROJECT_NAME
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="$PROJECT_NAME" \
      org.label-schema.description="A Fedora image that has new packages installed daily" \
      org.label-schema.url="https://www.debian.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/vcatechnology/docker-fedora" \
      org.label-schema.vendor="VCA Technology" \
      org.label-schema.version=$VERSION \
      org.label-schema.license=MIT \
      org.label-schema.schema-version="1.0"

# Update all packages
RUN dnf -y update && \
  dnf clean all --enablerepo=\*

# Generate locales
RUN cat /etc/locale.gen | expand | sed 's/^# .*$//g' | sed 's/^#$//g' | egrep -v '^$' | sed 's/^#//g' > /tmp/locale.gen \
  && mv -f /tmp/locale.gen /etc/locale.gen \
  && locale-gen
ENV LANG=en_GB.utf8

# Create install script
RUN touch                                 /usr/local/bin/vca-install-package && \
  chmod +x                                /usr/local/bin/vca-install-package && \
  echo '#! /bin/sh'                    >> /usr/local/bin/vca-install-package && \
  echo 'set -e'                        >> /usr/local/bin/vca-install-package && \
  echo 'dnf -y install $@'             >> /usr/local/bin/vca-install-package && \
  echo 'dnf clean all --enablerepo=\*' >> /usr/local/bin/vca-install-package

# Create uninstall script
RUN touch                    /usr/local/bin/vca-uninstall-package && \
  chmod +x                   /usr/local/bin/vca-uninstall-package && \
  echo '#! /bin/sh'       >> /usr/local/bin/vca-uninstall-package && \
  echo 'set -e'           >> /usr/local/bin/vca-uninstall-package && \
  echo 'dnf -y remove $@' >> /usr/local/bin/vca-uninstall-package

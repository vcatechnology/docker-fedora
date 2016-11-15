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
      org.label-schema.url="https://getfedora.org/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/vcatechnology/docker-fedora" \
      org.label-schema.vendor="VCA Technology" \
      org.label-schema.version=$VERSION \
      org.label-schema.license=MIT \
      org.label-schema.schema-version="1.0"

# Create install script
RUN touch                                                /usr/local/bin/vca-install-package \
 && chmod +x                                             /usr/local/bin/vca-install-package \
 && echo '#! /bin/sh'                                 >> /usr/local/bin/vca-install-package \
 && echo 'set -e'                                     >> /usr/local/bin/vca-install-package \
 && echo 'dnf -qy --setopt=deltarpm=false install $@' >> /usr/local/bin/vca-install-package \
 && echo 'dnf clean all --enablerepo=\*'              >> /usr/local/bin/vca-install-package

# Create uninstall script
RUN touch                                               /usr/local/bin/vca-uninstall-package \
 && chmod +x                                            /usr/local/bin/vca-uninstall-package \
 && echo '#! /bin/sh'                                >> /usr/local/bin/vca-uninstall-package \
 && echo 'set -e'                                    >> /usr/local/bin/vca-uninstall-package \
 && echo 'dnf -qy --setopt=deltarpm=false remove $@' >> /usr/local/bin/vca-uninstall-package \
 && echo 'dnf clean all --enablerepo=\*'             >> /usr/local/bin/vca-uninstall-package

# Set the locale
RUN vca-install-package langpacks-en_GB
ENV LANG=en_GB.UTF-8

# Update all packages
RUN dnf -qy --setopt=deltarpm=false update \
 && dnf clean all --enablerepo=\*

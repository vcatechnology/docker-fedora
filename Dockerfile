FROM fedora
MAINTAINER VCA Technology <developers@vcatechnology.com>

# Update all packages
RUN dnf -y update && \
  dnf clean all --enablerepo=\*

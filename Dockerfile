FROM centos:7

# install Varnish 7.3 from https://packagecloud.io/varnishcache
RUN curl -s https://packagecloud.io/install/repositories/varnishcache/varnish73/script.rpm.sh | bash

# the epel repo contains jemalloc
RUN yum install -y epel-release

# install our dependencies
RUN yum install -y \
    git \
    make \
    automake \
    libtool \
    python-sphinx \
    varnish-devel

# download the top of the varnish-modules 7.3 branch
RUN git clone --branch 7.3 --single-branch https://github.com/varnish/varnish-modules.git

# jump into the directory
WORKDIR /varnish-modules

# prepare the build, build, check and install
RUN ./bootstrap && \
    ./configure && \
    make && \
    make check -j 4 && \
    make install

# Prometheus exporter toggle-able with environment variable.  Check entrypoint
ENV ENABLE_PROMETHEUS_EXPORTER=false
RUN curl -o out.tar.gz \
    -L https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/1.4.1/prometheus_varnish_exporter-1.4.1.linux-386.tar.gz \
    && ls -lah \
    && tar -zxvf out.tar.gz prometheus_varnish_exporter-1.4.1.linux-386/prometheus_varnish_exporter \
    && chmod +x prometheus_varnish_exporter-1.4.1.linux-386/prometheus_varnish_exporter \
    && mv prometheus_varnish_exporter-1.4.1.linux-386/prometheus_varnish_exporter /usr/local/bin

ENV VARNISH_MALLOC=500M
ENV VARNISH_SEND_TIMEOUT=600;

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

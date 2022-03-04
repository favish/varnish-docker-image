FROM alpine:20190408

EXPOSE 80

# TODO - remove gettext/libintl, previously used for envsubst and unrelated utils for build - MEA
RUN apk add --no-cache \
        varnish \
        gettext \
        libintl \
        curl \
        && apk add --virtual \
        build_deps \
        gettext \
        libintl

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

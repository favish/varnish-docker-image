# Varnish Docker Image

Container runs varnish with a prometheus exporter for metrication and will provide varnishcsa as it's containers log output for ingestion into your cluster log viewer.

### Notes
 
This varnish image differs from stockin a few key ways:

* Supports prometheus exporter
* Configured to allow large headers to enable Surrogate cache tags to be easily cleared:
  ```
  -p http_resp_hdr_len=16k
  ```
### Use
You usually want to mount VCL configuration into /etc/varnish to use:

```
volumeMounts:
          - name: "config"
            mountPath: "/etc/varnish/default.vcl"
            subPath: "default.vcl"
```

[Dockerfile on GitHub](https://github.com/favish/varnish-docker-image)

### History
This repo was previously included in a [mono repo](https://github.com/favish/docker-images) and the last published
tag with that repo was `varnish-6_alpine_1.2.1`. The CircleCI build process now publishes to a new image
on [Dockerhub](https://hub.docker.com/repository/docker/favish/varnish).
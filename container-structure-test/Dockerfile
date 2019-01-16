FROM buildpack-deps:stretch-curl
RUN curl -L https://storage.googleapis.com/container-structure-test/v1.7.0/container-structure-test-linux-amd64 -o /container-structure-test && \
  chmod +x /container-structure-test
FROM gcr.io/distroless/base:latest
COPY --from=gcr.io/kaniko-project/executor:debug /busybox /busybox
COPY --from=0 /container-structure-test /busybox/container-structure-test
ENV PATH $PATH:/busybox
ENTRYPOINT ["/busybox/container-structure-test"]
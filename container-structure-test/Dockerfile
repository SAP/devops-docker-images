FROM gcr.io/kaniko-project/executor:debug as busybox
FROM buildpack-deps:stretch-curl as executable
RUN curl -L https://storage.googleapis.com/container-structure-test/v1.8.0/container-structure-test-linux-amd64 -o /container-structure-test && \
  chmod +x /container-structure-test
# hadolint ignore=DL3007
FROM gcr.io/distroless/base:latest as runner
COPY --from=busybox /busybox /busybox
COPY --from=executable /container-structure-test /busybox/container-structure-test
ENV PATH $PATH:/busybox
ENTRYPOINT ["/busybox/container-structure-test"]

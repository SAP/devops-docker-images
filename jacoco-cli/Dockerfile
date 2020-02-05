FROM alpine:latest as builder
RUN apk --no-cache add ca-certificates wget unzip
RUN wget -O jacoco.zip http://search.maven.org/remotecontent?filepath=org/jacoco/jacoco/0.8.5/jacoco-0.8.5.zip && unzip jacoco.zip

FROM openjdk:8-jre-slim

COPY --from=builder lib/jacococli.jar /

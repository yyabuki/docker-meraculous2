FROM debian:jessie

MAINTAINER Yukimitsu Yabuki, yukimitsu.yabuki@gmail.com
# A bit modified a Dockerfile and an attached file (run) created by Eugene Goltsman.

RUN apt-get update -y
RUN apt-get install -y g++ build-essential cmake perl gnuplot libboost-dev libboost-thread-dev wget
RUN cpan -f Log::Log4perl

RUN wget \
  http://portal.nersc.gov/dna/plant/assembly/meraculous2/releases/release-2.0.5-docker.tgz \
  --output-document /tmp/meraculous2.tar.gz \
  --quiet
RUN mkdir -p /tmp/meraculous2/build
RUN tar xzf /tmp/meraculous2.tar.gz --directory /tmp/meraculous2 --strip-components=1
RUN cd /tmp/meraculous2/build && \
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ -DCMAKE_BUILD_TYPE=Release .. && \
  make && \
  make install

ENV MERACULOUS_ROOT /usr/local/

ADD http://portal.nersc.gov/dna/plant/assembly/meraculous2/extras/qqacct /usr/local/bin/

ADD run /usr/local/bin/
ADD Procfile /
ENTRYPOINT ["/usr/local/bin/run"]

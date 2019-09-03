FROM tatsushid/tinycore:10.0-x86_64 AS kvdo-build

LABEL maintainer="hpmtissera@gmail.com"

RUN tce-load -wci bash
RUN tce-load -wci openssl-dev
RUN tce-load -wci gcc
RUN tce-load -wci compiletc
RUN tce-load -wci readline-dev
RUN tce-load -wci cmake
RUN tce-load -wci git
RUN tce-load -wci elfutils-dev
RUN tce-load -wci gzip
RUN tce-load -wci bc
RUN tce-load -wci coreutils

RUN wget -P /tmp https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.10.tar.xz

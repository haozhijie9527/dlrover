FROM easydl/easydl:ci as builder

WORKDIR /dlrover
COPY ./ .
RUN sh scripts/build_wheel.sh

FROM python:3.8.14 as base
RUN sed -i -E 's/(deb|security).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN pip install pyparsing -i https://mirrors.aliyun.com/pypi/simple
RUN pip install ping3 -i https://mirrors.aliyun.com/pypi/simple
#RUN apt-get update & apt-get install inetutils-ping


ENV VERSION="0.3.0rc1"
COPY --from=builder /dlrover/dist/dlrover-${VERSION}-py3-none-any.whl /
RUN pip install /dlrover-${VERSION}-py3-none-any.whl[k8s] --extra-index-url=https://mirrors.aliyun.com/pypi/simple && rm -f /*.whl
RUN unset VERSION
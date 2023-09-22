FROM easydl/easydl:ci as builder

WORKDIR /dlrover
COPY ./ .
RUN sh scripts/build_wheel.sh

FROM easydl/dlrover-cpu:torch201-py38  as base

WORKDIR /dlrover

RUN apt-get update && apt-get install -y sudo
RUN apt-get install inetutils-ping

COPY ./data .
COPY --from=builder /dlrover/dist/dlrover-*.whl /
RUN pip install Pillow -i https://mirrors.aliyun.com/pypi/simple
RUN pip install /*.whl --extra-index-url=https://mirrors.aliyun.com/pypi/simple && rm -f /*.whl

COPY ./examples ./examples
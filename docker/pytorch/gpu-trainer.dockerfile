FROM easydl/easydl:ci as builder

WORKDIR /dlrover
COPY ./ .
RUN sh scripts/build_wheel.sh

FROM nvidia/cuda:11.7.1-base-ubuntu18.04 as base

WORKDIR /dlrover

COPY --from=builder /dlrover/dist/dlrover-*.whl /

RUN sed -i -E 's/(archive|security).ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
#RUN sed -i '1s/deb /deb [trusted=yes] /' /etc/apt/sources.list.d/cuda.list && \
#    sed -i '1s/deb /deb [trusted=yes] /' /etc/apt/sources.list.d/nvidia-ml.list
#
## 1、编译服务器时间必须校准，2、A4B469963BF863CC依据实际编译环境而定
#RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com A4B469963BF863CC

# Install Python 3.8 and pip
RUN apt-get update && apt-get install -y \
    python3.8 python3-pip python3.8-venv python3.8-dev wget vim curl && \
    ln -s /usr/bin/python3.8 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && rm get-pip.py && \
    pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple

RUN pip install urllib3==1.21.1 grpcio==1.34.1 grpcio-tools==1.34.1 protobuf==3.20.3 -i https://mirrors.aliyun.com/pypi/simple
RUN pip install pyyaml \
        astunparse \
        expecttest \
        hypothesis \
        numpy \
        psutil \
        pyyaml \
        requests \
        setuptools \
        types-dataclasses \
        typing-extensions \
        sympy \
        filelock \
        networkx \
        jinja2 \
        fsspec  -i https://mirrors.aliyun.com/pypi/simple

# https://pytorch.org/get-started/previous-versions/
# https://hub.docker.com/r/nvidia/cuda
# https://github.com/NVIDIA/nvidia-docker
# https://hub.docker.com/r/nvidia/cuda/tags
# https://zhuanlan.zhihu.com/p/149296389
COPY docker/pkg/gpu/*.whl /
#RUN pip install torch==2.0.0+cu117 torchvision==0.15.1+cu117 torchaudio==2.0.1+cu117 \
#    -f https://download.pytorch.org/whl/torch_stable.html

RUN pip install /*.whl --extra-index-url=https://mirrors.aliyun.com/pypi/simple --no-deps && \
    rm -f /*.whl
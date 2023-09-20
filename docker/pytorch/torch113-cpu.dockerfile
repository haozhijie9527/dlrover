FROM easydl/easydl:ci as builder

WORKDIR /dlrover
COPY ./ .
RUN sh scripts/build_wheel.sh

FROM python:3.8.14 as base
RUN sed -i -E 's/(deb|security).debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list

RUN apt update
RUN apt install -y libgl1-mesa-glx libglib2.0-dev vim
RUN pip install deprecated pyparsing -i https://mirrors.aliyun.com/pypi/simple
COPY docker/pkg/cpu/*.whl /
#RUN pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 opencv-python

COPY --from=builder /dlrover/dist/dlrover-*.whl /
RUN pip install /*.whl --extra-index-url=https://mirrors.aliyun.com/pypi/simple && rm -f /*.whl

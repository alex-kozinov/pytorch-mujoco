# References
# 1. https://github.com/openai/mujoco-py/issues/284#issuecomment-456661913
# 2. https://github.com/openai/mujoco-py/issues/773#issuecomment-1650482758
# 3. https://github.com/facebookresearch/nougat/issues/40#issuecomment-1713702899

# Feel free to change the image below to your prefer base image. 🙃
FROM nvcr.io/nvidia/pytorch:25.05-py3 

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

# Update, upgrade, install packages, install python if PYTHON_VERSION is specified, clean up
RUN apt-get -qq update --yes && \
    apt-get -qq upgrade --yes && \
    apt -qq install --yes --no-install-recommends git wget curl bash libgl1 openssh-server nginx && \
    apt-get -qq autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

RUN apt-get -qq update
RUN apt-get -qq install build-essential --yes
RUN apt-get install libosmesa6-dev --yes
RUN apt-get install libegl1 libglvnd0 --yes
RUN apt-get install -y ffmpeg

# Remove existing SSH host keys
RUN rm -f /etc/ssh/ssh_host_*

# NGINX Proxy
COPY proxy/nginx.conf /etc/nginx/nginx.conf
COPY proxy/readme.html /usr/share/nginx/html/readme.html

# Copy the README.md
COPY README.md /usr/share/nginx/html/README.md

# Start Scripts
COPY scripts/start.sh /start.sh
RUN chmod 755 /start.sh

ENV LD_LIBRARY_PATH="/usr/local/lib/python3.10/dist-packages/torch/lib:\
/usr/local/lib/python3.10/dist-packages/torch_tensorrt/lib:\
/usr/local/cuda/compat/lib:\
/usr/local/nvidia/lib:\
/usr/local/nvidia/lib64:\
/root/.mujoco/mujoco210/bin"

# Set the working directory
WORKDIR /

RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade --no-cache-dir jupyterlab ipywidgets jupyter-archive 

# To run Mujoco, its path must be included into '$LD_LIBRARY_PATH'.
WORKDIR /root/.mujoco

RUN wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz && \
    tar --no-same-owner -xvzf mujoco210-linux-x86_64.tar.gz && \
    rm -rf /root/.mujoco/mujoco210/sample /root/.mujoco/mujoco210/model/sponge.png

# Installation check
# RUN python -c "import gymnasium as gym; gym.make('Ant-v4')"
# RUN python -c "from flax import struct"

# Welcome Message
RUN echo 'cat /etc/runpod.txt' >> /root/.bashrc
RUN echo 'echo -e "\nFor detailed documentation and guides, please visit:\n\033[1;34mhttps://docs.runpod.io/\033[0m and \033[1;34mhttps://blog.runpod.io/\033[0m\n\n"' >> /root/.bashrc

# Set the default command for the container
CMD [ "/start.sh" ]

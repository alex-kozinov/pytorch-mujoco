# References
# 1. https://github.com/openai/mujoco-py/issues/284#issuecomment-456661913
# 2. https://github.com/openai/mujoco-py/issues/773#issuecomment-1650482758
# 3. https://github.com/facebookresearch/nougat/issues/40#issuecomment-1713702899

# Feel free to change the image below to your prefer base image. 🙃
FROM nvcr.io/nvidia/pytorch:23.10-py3 

RUN apt-get update
RUN apt-get install build-essential --yes
RUN apt-get install python3.10-dev --yes
RUN apt-get install libosmesa6-dev --yes


ENV LD_LIBRARY_PATH="/usr/local/lib/python3.10/dist-packages/torch/lib:\
/usr/local/lib/python3.10/dist-packages/torch_tensorrt/lib:\
/usr/local/cuda/compat/lib:\
/usr/local/nvidia/lib:\
/usr/local/nvidia/lib64:\
/root/.mujoco/mujoco210/bin"
# To run Mujoco, its path must be included into '$LD_LIBRARY_PATH'.

WORKDIR /root/.mujoco
RUN wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz
RUN tar -xvzf mujoco210-linux-x86_64.tar.gz


RUN pip install swig==4.2.1
RUN pip install "gymnasium[all]==0.29.1"
RUN pip install "mujoco-py==2.1.2.14"
RUN pip install "cython<3"
RUN pip install opencv-python==4.8.0.74
RUN python -c "import gymnasium as gym; gym.make('Ant-v4')"

WORKDIR /
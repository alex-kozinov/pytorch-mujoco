```bash
docker build --tag mujoco-gym https://github.com/howsmyanimeprofilepicture/mujoco-gym.git
```

1. This image provides the isolated Mujoco environment. If there's an error in this image, feel free to [submit an issue](https://github.com/howsmyanimeprofilepicture/scripts/issues/new)! 😀
2. The default base image is `nvcr.io/nvidia/pytorch:23.10-py3` whose size is 9.87 GB. If it is too huge, feel free to change it to your prefer base image.


It was painful for me to setup the Mujoco environment. So, I prefer to containerise the entire environment to isolate it from the host machine. 
To reduce the sum of pains in the world, I disclose this image. I hope it helps you.


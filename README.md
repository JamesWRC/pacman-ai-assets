using bazel 3.1.0 compiled on a AWS 32 vCPU (minimum) machine (arm64) 
Known issue:
```
------
 > [23/23] RUN bazel build --config=opt --verbose_failures //tensorflow/tools/pip_package:build_pip_package:
#26 0.392 Opening zip "/proc/self/exe": lseek(): Bad file descriptor
#26 0.393 FATAL: Failed to open '/proc/self/exe' as a zip file: (error: 9): Bad file descriptor
executor failed running [/bin/sh -c bazel build --config=opt --verbose_failures //tensorflow/tools/pip_package:build_pip_package]: exit code: 36
```
fix it, by running the bellow comand and trying it again, it should nwo run bazel:
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

then build with:
```
docker buildx build --platform linux/arm64 -t tensor .
```

# Needed dependencies for Tensorflow
pip install numpy --upgrade

best hardware to compile on ~32 cores, ~48 GB RAM, 20Gb storage.
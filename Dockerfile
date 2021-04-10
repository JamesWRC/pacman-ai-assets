FROM arm64v8/ubuntu:latest
LABEL maintainer="github.com/JamesWRC"
ENV DEBIAN_FRONTEND=noninteractive


# manual install
RUN apt update  
RUN apt upgrade -y 

RUN apt install -y python3-dev python3-pip 
RUN apt install -y build-essential 
RUN apt update --fix-missing
RUN apt install -y openjdk-11-jdk 
RUN apt install -y python zip unzip 
RUN apt install -y wget 
RUN apt install -y git 

RUN pip3 install --upgrade pip  
RUN pip3 install --user pip numpy wheel  
RUN pip3 install --user keras_preprocessing --no-deps 
RUN pip3 install --user boto3


RUN mkdir bazel_3_1_0 
WORKDIR /bazel_3_1_0
RUN wget https://github.com/bazelbuild/bazel/releases/download/3.1.0/bazel-3.1.0-dist.zip 

RUN unzip bazel-3.1.0-dist.zip 
RUN EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh 

RUN chmod +x output/bazel 
RUN cp output/bazel /usr/bin/ 

RUN git clone -b r2.4 --single-branch --depth 3 https://github.com/tensorflow/tensorflow.git 

ENV TF_NEED_MKL=0  
ENV TF_DOWNLOAD_MKL=0 
ENV TF_NEED_AWS=0 
ENV TF_NEED_MPI=0 
ENV TF_NEED_GDR=0 
ENV TF_NEED_S3=0 
ENV TF_NEED_OPENCL_SYCL=0 
ENV TF_SET_ANDROID_WORKSPACE=0 
ENV TF_NEED_COMPUTECPP=0 
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-arm64/

WORKDIR /bazel_3_1_0/tensorflow  
RUN git branch

RUN pwd && ls
RUN ./configure 
RUN echo "building...."
RUN bazel version
RUN bazel clean --expunge
RUN bazel --version
RUN bazel build --config=opt -c opt --noincompatible_do_not_split_linking_cmdline --local_ram_resources=1950000 --local_cpu_resources=126 --jobs 126 --verbose_failures //tensorflow/tools/pip_package:build_pip_package

COPY uploadAssetsToS3.py uploadAssetsToS3.py 


CMD python3 uploadAssetsToS3.py 

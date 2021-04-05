FROM arm64v8/ubuntu:latest
LABEL maintainer="github.com/JamesWRC"
ENV DEBIAN_FRONTEND=noninteractive

# manual install
RUN apt update  
RUN apt upgrade -y 
RUN apt install -y python3-dev python3-pip 
RUN pip3 install --upgrade pip  
RUN pip3 install -U --user pip numpy wheel  
RUN pip3 install -U --user keras_preprocessing --no-deps 
RUN apt install -y wget 
RUN apt install -y git 


RUN mkdir bazel_3_7_2 
WORKDIR /bazel_3_7_2
RUN wget https://github.com/bazelbuild/bazel/releases/download/3.7.2/bazel-3.7.2-dist.zip 
RUN apt install -y build-essential openjdk-11-jdk python zip unzip 
RUN unzip bazel-3.7.2-dist.zip 
RUN EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh 

RUN chmod +x output/bazel 
RUN cp output/bazel /usr/bin/ 
RUN ls
RUN git clone --depth 3 https://github.com/tensorflow/tensorflow.git 

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

WORKDIR /bazel_3_7_2/tensorflow  


RUN pwd && ls
RUN ./configure 
RUN bazel
RUN bazel build --config=opt --local_ram_resources=8000 --local_cpu_resources=4 --verbose_failures //tensorflow/tools/pip_package:build_pip_package



# RUN bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package


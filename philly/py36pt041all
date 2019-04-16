FROM phillyregistry.azurecr.io/philly/jobs/base/philly-openmpi:1.10.3-ubuntu.16.04-cuda.9.0-cudnn.7

# Copy the files to the necessary folder
COPY toolkit-execute /home/job/toolkit-execute
RUN chmod u+x /home/job/toolkit-execute

# Labels for the docker
LABEL description="This docker has pytorch 0.4.1, gym[atari], pytorchvision opencv in anaconda python36 with cuda 9.0, and cudnn 7.0." \
      lepository="philly/jobs/custom/pytorch" \
      tag="py36pt041all" \
      creator="v-yuewng" tooltype="pytorch" \
      tooltypeversion="0.4.1" \
      createtime="4/16/2019"
# Everything above this line is required for the docker.
# Add your personalized features below here.

RUN apt-get update && apt-get install -y --no-install-recommends \
         git \
         ca-certificates \
         libnccl2 \
         libnccl-dev \
         libjpeg-dev \
         libboost-all-dev\
         libsdl2-dev\
         libgl1-mesa-dev\
         swig\
         vim\
         tmux\
         htop\
         xorg-dev\
         unzip\
         cmake zlib1g-dev libjpeg-dev xvfb libav-tools \
         libpng-dev &&\
         rm -rf /var/lib/apt/lists/*

ENV PYTHON_VERSION=3.6

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda create -y --name pytorch-py$PYTHON_VERSION python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl&& \
     /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/envs/pytorch-py$PYTHON_VERSION/bin:$PATH

RUN /opt/conda/bin/conda install --name pytorch-py$PYTHON_VERSION cuda90 pytorch=0.4.1 torchvision -c pytorch  && \
    /opt/conda/bin/conda clean -ya

RUN pip install h5py keras future chainer cupy

RUN pip install  gym  && \
    pip install  gym[atari]  && \
    pip install opencv-python && \ 
    pip install tqdm   && \
    pip install tensorboardX pytz logger matplotlib



Run pip uninstall -y  Box2D-kengz ; \  
    git clone https://github.com/pybox2d/pybox2d.git && \ 
    cd pybox2d && ls && \ 
    python setup.py build && \ 
    python setup.py install && \ 
    cd .. && rm -rf pybox2d  

WORKDIR /opt
RUN apt-get update && apt-get install -y \
      git cmake ffmpeg pkg-config \
      qtbase5-dev libqt5opengl5-dev libassimp-dev \
      libpython3.5-dev libboost-python-dev libtinyxml-dev \
    && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    && git clone --depth 1 https://github.com/olegklimov/bullet3 -b roboschool_self_collision \
    && git clone --depth 1 https://github.com/openai/roboschool

ENV ROBOSCHOOL_PATH /opt/roboschool  

RUN /opt/conda/bin/conda install --name pytorch-py$PYTHON_VERSION -c conda-forge boost &&\
    /opt/conda/bin/conda install --name pytorch-py$PYTHON_VERSION  -c flyem-forge assimp &&\
    /opt/conda/bin/conda install --name pytorch-py$PYTHON_VERSION -c conda-forge pyqt ffmpeg


ENV   ROBOSCHOOL_PATH=/opt/roboschool \
  PKG_CONFIG_PATH=/opt/conda/lib/pkgconfig \
  LD_LIBRARY_PATH=/opt/conda//lib:$LD_LIBRARY_PATH \
  LIBRARY_PATH=/opt/conda/lib:$LIBRARY_PATH \ 
  C_INCLUDE_PATH=/opt/conda/include:/opt/conda/include/python3.6m  \
  CPLUS_INCLUDE_PATH=/opt/conda/include:/opt/conda/include/python3.6m

RUN mkdir -p /opt/bullet3/build \
    && cd /opt/bullet3/build \
    && cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 \
       -DCMAKE_INSTALL_PREFIX:PATH=${ROBOSCHOOL_PATH}/roboschool/cpp-household/bullet_local_install \
       -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF \
       -DBUILD_EXTRAS=OFF  -DBUILD_UNIT_TESTS=OFF \
       -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF \
       -DBUILD_OPENGL3_DEMOS=OFF .. \
    && make -j16 \
    && make install \
    && pip install -e ${ROBOSCHOOL_PATH} \
    && ldconfig \
    && make clean
 

RUN pip uninstall  -y roboschool && pip install pandas tensorflow-gpu   roboschool
WORKDIR /opt
RUN git clone https://github.com/openai/baselines.git \
&& cd baselines \
&& pip install -e .

RUN pip install gym[atari]

ENV PATH /opt/conda/envs/pytorch-py$PYTHON_VERSION/bin:$PATH
WORKDIR /workspace
RUN chmod -R a+w /workspace


ENV LANG C.UTF-8 
RUN wget https://github.com/pytorch/fairseq/archive/v0.6.1.tar.gz && tar -zxvf v0.6.1.tar.gz
RUN cd /workspace/fairseq-0.6.1 && pip install --editable .


ENV LANG C.UTF-8
WORKDIR /workspace/fairseq-0.6.1
RUN cd  examples/translation/ \
    &&  bash prepare-iwslt14.sh \
    && cd ../.. \
    && TEXT=examples/translation/iwslt14.tokenized.de-en \
    && python preprocess.py --source-lang de --target-lang en \
  --trainpref $TEXT/train --validpref $TEXT/valid --testpref $TEXT/test \
  --destdir data-bin/iwslt14.tokenized.de-en --joined-dictionary



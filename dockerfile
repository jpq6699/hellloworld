FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
  
RUN apt-get update && apt-get install -y \
                build-essential \
                cmake \
                curl \
                g++ \
                gfortran \
                wget \
                bzip2 \
                git \
                mercurial \
                vim \
                tmux \
                cmake \
                libboost-all-dev \
                ffmpeg \
                parallel \
                imagemagick \
                unrar \
                libsm6 \
                libxrender1 \
                libfontconfig1 \
                mc \
                screen \
                man-db \
                nvidia-cuda-toolkit

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl https://rclone.org/install.sh | bash

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN pip install --upgrade pip

RUN pip install scipy imageio pyyaml pyssim joblib easydict docopt tqdm pyyaml \
                      Pillow scikit-image opencv-python pytube \
                      numpy tensorboardX

RUN conda install -c menpo ffmpeg

RUN rm -rf /root/.cache/pip

RUN conda install pytorch torchvision cudatoolkit -c pytorch

RUN set -x \
    && wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini \
    && echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - \
    && mv tini /usr/local/bin/tini \
    && chmod +x /usr/local/bin/tini

ENTRYPOINT ["tini", "--"]
CMD [ "/bin/bash" ]

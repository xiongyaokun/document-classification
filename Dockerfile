# ==============================================================================
# 🐳 Dockerfile for CPU
# ------------------------------------------------------------------------------
#
FROM ubuntu:16.04
LABEL maintainer="Goku Mohandas <gokumd@gmail.com>" \
      name="practicalai/practicalai:cpu" \
      url="https://hub.docker.com/r/practicalai/practicalai/tags" \
      vcs-url="https://github.com/practicalAI/dockerfiles" \
      version="1.0"

# ==============================================================================
# 🚀 Initialize
# ------------------------------------------------------------------------------
#
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade" && \
    JUPYTER_KERNEL="practicalai" && \
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
#
# ==============================================================================
# ⚙️ Tools
# ------------------------------------------------------------------------------
#
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        wget \
        git \
        vim \
        && \
#
# ==============================================================================
# 🐍 Python
# ------------------------------------------------------------------------------
#
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        software-properties-common \
        && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python3.6 \
        python3.6-dev \
        && \
    wget -O ~/get-pip.py \
        https://bootstrap.pypa.io/get-pip.py && \
    python3.6 ~/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    $PIP_INSTALL \
        setuptools \
        && \
    $PIP_INSTALL \
        numpy \
        scipy \
        pandas \
        scikit-learn \
        matplotlib \
        && \
#
# ==============================================================================
# 📓 Jupyter notebook
# ------------------------------------------------------------------------------
#
    $PIP_INSTALL \
        jupyter \
        && \
#
# ==============================================================================
# 🔥 PyTorch
# ------------------------------------------------------------------------------
#
    $PIP_INSTALL \
        numpy \
        torchvision_nightly \
        && \
    $PIP_INSTALL \
        torch_nightly -f \
        https://download.pytorch.org/whl/nightly/cpu/torch_nightly.html \
        && \
#
# ==============================================================================
# 🌊 TensorFlow
# ------------------------------------------------------------------------------
#
    $PIP_INSTALL \
        tensorflow \
        && \
#
# ==============================================================================
# 🔱 Keras
# ------------------------------------------------------------------------------
#
    $PIP_INSTALL \
        h5py \
        keras

# ==============================================================================
# 🛁 Clean up
# ------------------------------------------------------------------------------
#
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* ~/*

# ==============================================================================
# 🚢 Ports
# ------------------------------------------------------------------------------
#
EXPOSE 8888 6006 5000

# ==============================================================================
# 📖 Document classification
# ------------------------------------------------------------------------------
#
ARG DIR
COPY . $DIR/
WORKDIR $DIR/
RUN pip install -r requirements.txt && \
    python setup.py develop
ENV DIR ${DIR}
WORKDIR $DIR/document_classification
CMD gunicorn -c gunicorn_config.py application

FROM ubuntu:20.04
MAINTAINER mortimerzhu

ENV TZ="Asia/Shanghai"

RUN set -x && \
    sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y tzdata &&\
    ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get install -y \
            autoconf \
            automake \
            autotools-dev \
            build-essential \
            curl \
            git \
            wget \
            libtinfo-dev \
            openssh-server \
            pkg-config \
            global \
            libgnutls.*-dev

RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 30/' /etc/ssh/sshd_config && \
    sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 60/' /etc/ssh/sshd_config

COPY emacs-27.2.tar.gz /opt/
COPY setup_emacs.sh /opt/

RUN cd /opt/ && \
    chmod 777 setup_emacs.sh && \
    tar xf emacs-27.2.tar.gz && \
    cd emacs-27.2 && \
    ./autogen.sh && \
    ./configure --without-x && \
    make -j8 && \
    make install

EXPOSE 22
ENTRYPOINT  ["/usr/sbin/sshd", "-D"]

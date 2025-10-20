#!/bin/bash

apt update

apt install -y build-essential checkinstall \
    libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev curl \
    llvm libncurses5-dev libgdbm-dev \
    libnss3-dev libssl-dev liblzma-dev \
    tk-dev libffi-dev libsqlite3-dev \
    libreadline-dev libbz2-dev wget

cd /tmp
wget https://www.python.org/ftp/python/3.9.9/Python-3.9.9.tgz

tar -xvzf Python-3.9.9.tgz
cd Python-3.9.9

./configure --enable-optimizations --prefix=/usr/local

# Compile Python from source (this may take some time)
make -j$(nproc)

make altinstall

# Install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
/usr/local/bin/python3.9 get-pip.py
rm get-pip.py

update-alternatives --install /usr/bin/python python /usr/local/bin/python3.9 1
update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.9 1

python --version
pip --version

echo "Python 3.9 and pip have been installed and configured from source."
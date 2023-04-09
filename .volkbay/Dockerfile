# Author: @volkbay[2023]
#
## Example Usage ##
##
## Build image with:    `docker build -t eklt-vio .`
## Run container with:  `docker run -it -v <host_dataset_dir>:<container_dataset_dir> eklt-vio`
## Load environment:    `source ../devel/setup.bash`
## Evaluate with:       `python3 x_evaluate/test/evaluate.py --configuration x_evaluate/test/evaluate.yaml ...
##                      --output_folder <container_dataset_dir>/<dataset>/output ...
##                      --dataset_dir <container_dataset_dir> --frontend XVIO --name "XVIO"`
##
## 
FROM osrf/ros:noetic-desktop-full

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git python3-vcstool python3-catkin-tools libtool nano \
    python3-pip

# Install Eigen3 v3.4 (required by Haste Lib used in X Lib, this version cannot be found in apt repo for Ubuntu 20.04)
WORKDIR /home
RUN     git clone https://gitlab.com/libeigen/eigen.git && \
        mkdir -p /home/eigen/build    
WORKDIR /home/eigen/build
RUN     cmake ../ -DCMAKE_INSTALL_PREFIX=/usr/local && \
        make install

# Init catkin environment
ENV WORKSPACE /eklt_vio_ws
RUN mkdir -p /${WORKSPACE}/src
WORKDIR ${WORKSPACE}
RUN catkin init &&\
    catkin config --extend /opt/ros/noetic

# Clone dependencies and modify CMake configurations
WORKDIR ${WORKSPACE}/src

#TODO: @volkbay: Change volkbay to jpl-x if PR accepted
RUN git clone https://github.com/volkbay/x_evaluate.git && \
    ## Following `sed` is required to clone git repos by HTTPS ...
    ## without global git configurations.
    sed -i 's+git@github.com:+https://github.com/+g' x_evaluate/dependencies.yaml && \ 
    vcs-import < x_evaluate/dependencies.yaml
    
# Build Catkin packages
RUN catkin build -j${nproc} x_evaluate

RUN pip3 install -r x_evaluate/requirements.txt && \
    pip3 install ./x_evaluate

# Run container
ENTRYPOINT [ "/bin/bash" ]
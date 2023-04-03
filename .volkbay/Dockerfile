# Author: @volkbay[2023]
FROM osrf/ros:noetic-desktop-full

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git python3-vcstool python3-catkin-tools libtool nano

# Install Eigen3 3.4 (required by Haste Library) (not found in apt repo)
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
RUN git clone https://github.com/volkbay/x_evaluate.git && \
    ## Following `sed` is required to clone git repos by HTTPS ...
    ## without global git configurations.
    sed -i 's+git@github.com:+https://github.com/+g' x_evaluate/dependencies.yaml && \ 
    vcs-import < x_evaluate/dependencies.yaml
    
# Build Catkin packages
RUN catkin build -j${nproc} x_evaluate

ENTRYPOINT [ "/bin/bash && source ${WORKSPACE}/devel/setup.bash" ]

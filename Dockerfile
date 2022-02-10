# This is an auto generated Dockerfile for ros:ros-core
# generated from docker_images/create_ros_core_image.Dockerfile.em
FROM ubuntu:bionic

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# install basic packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    net-tools \
    pkg-config \
    wget \
    apt-utils \
    build-essential \
    git \
    curl \
    cmake \
    vim \
    openbox \
    && rm -rf /var/lib/apt/lists/*

# install packages for x11 tests
RUN apt-get update && apt-get install -y \
    x11-apps \
    mesa-utils\
    && rm -rf /var/lib/apt/lists/*

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO melodic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-desktop-full=1.4.1-0* \
    python-rosdep \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./ros_entrypoint.sh /
RUN bash -c "chmod +x /ros_entrypoint.sh"
RUN apt-get update

# create user
RUN useradd -ms /bin/bash user01
RUN echo 'user01:newpassword' | chpasswd
RUN adduser user01 sudo
USER user01
WORKDIR /home/user01
CMD ["cp", "/root/.bashrc", "~/"]

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

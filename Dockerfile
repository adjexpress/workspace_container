FROM debian:latest


RUN sed -i -e 's/main/main contrib/' /etc/apt/sources.list
# RUN sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
# RUN sed -i "/^# deb.*universe/ s/^# //" /etc/apt/sources.list

# RUN echo "deb  http://deb.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
# RUN echo "deb-src  http://deb.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
#
RUN cat /etc/apt/sources.list
# RUN cat /etc/apt/sources.list

# RUN apt-get update && apt-get install -y software-properties-common
# RUN add-apt-repository universe
# RUN add-apt-repository multiverse
RUN apt-get update && apt-get install -y \
	sed \
	binutils \
	build-essential \
	make \
	gcc \
	g++ \
	bash \
	patch \
	gzip \
	bzip2 \
	perl \
	tar \
	cpio \
	unzip \
	rsync \
	file \
	bc \
	wget \
	python \
	git \
	mercurial \
	subversion \
	cvs \
	sudo \
	libncurses5 \
	openssh-client \
	bzr \
	whiptail \
	debianutils

	
RUN apt-get update && apt-get install -y \
	libncurses5-dev \
	libncursesw5-dev \
	swig \
	openssl \
	libssl-dev \
	dosfstools

RUN apt-get update && apt-get install -y \
    uuid-dev \
    iasl \
    nasm \
    python3-apt \
    liblzo2-dev


RUN apt-get update && apt-get install -y -f

RUN apt-get update && apt-get install -y locales libclang-dev pkg-config qemu-user-static systemd-container libusb-1.0-0 zsh graphviz sshpass
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
    
    
RUN useradd -c 'adj user' -m -d /home/adj -s /bin/zsh adj
RUN sed -i -e '/\%sudo/ c \%sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
RUN usermod -a -G sudo adj

ADD ./overlay/  /
RUN echo "## zsh config ..."
# RUN sh  install.sh
RUN sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN cp -r /root/.oh-my-zsh/ /home/adj/
RUN cp /root/.zshrc /home/adj/.zshrc


# Android build env
RUN apt-get install git ccache automake flex lzop bison \
	gperf build-essential zip curl zlib1g-dev zlib1g-dev \
	g++-multilib libxml2-utils bzip2 libbz2-dev \
	libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush \
	schedtool dpkg-dev liblz4-tool make optipng maven libssl-dev \
	pwgen libswitch-perl policycoreutils minicom libxml-sax-base-perl \
	libxml-simple-perl bc libc6-dev-i386 lib32ncurses5-dev \
	x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev xsltproc unzip

USER adj

RUN ssh-keygen -b 2048 -t rsa -f /home/adj/.ssh/id_rsa -q -N ""

WORKDIR /opt/workspace

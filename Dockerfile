#The Target OS is set to be the last stable version of Ubuntu
FROM ubuntu:18.04
# STEPS

#1) Run the helm tool
#Disclaimer: This tool is used to have a running container inside Github Actions
# 	     otherwise, it is not possible, since it is closed by default
# ------------------------------------------------------------------------------
ENV SHELL /bin/bash
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh
RUN source ~/.profile
RUN export GPG_TTY=$(tty)
RUN apt-get update
RUN apt --assume-yes install git
RUN apt-get --assume-yes install curl
RUN curl -L https://git.io/get_helm.sh | bash
# ------------------------------------------------------------------------------

#2) Create all directories that are necessary
#Disclaimer: The command COPY just copies contents of a directory
# ------------------------------------------------------------------------------
RUN mkdir /root/DeSCAM
RUN mkdir /root/AppImage
RUN mkdir /root/DeSCAM/install
RUN mkdir /root/DeSCAM/src
RUN mkdir /root/DeSCAM/doc
RUN mkdir /root/DeSCAM/example
RUN mkdir /root/DeSCAM/tests
# ------------------------------------------------------------------------------

#3) Copy all required contents to create the AppImage
#Disclaimer: only needed files are copied for size optmization
# ------------------------------------------------------------------------------
COPY AppImage  /root/AppImage/
COPY install  /root/DeSCAM/install/
COPY src  /root/DeSCAM/src/
COPY doc  /root/DeSCAM/doc/
COPY example /root/DeSCAM/example/
COPY tests /root/DeSCAM/tests/
COPY transcript /root/DeSCAM/
COPY CMakeLists.txt /root/DeSCAM/
COPY master /root/
# ------------------------------------------------------------------------------

#4) Change working dir and start bash
# ------------------------------------------------------------------------------
WORKDIR /apps
ENTRYPOINT tail -f /dev/null
CMD [ "/bin/bash" ]
# ------------------------------------------------------------------------------


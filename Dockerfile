FROM ubuntu:18.04
ENV SHELL /bin/bash
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh
RUN source ~/.profile
RUN export GPG_TTY=$(tty)
RUN apt-get update
RUN apt --assume-yes install git
RUN apt-get --assume-yes install curl
RUN curl -L https://git.io/get_helm.sh | bash
RUN mkdir /root/DeSCAM
RUN mkdir /root/AppImage
COPY AppImage  /root/AppImage/
RUN mkdir /root/DeSCAM/install
COPY install  /root/DeSCAM/install/
RUN mkdir /root/DeSCAM/src
COPY src  /root/DeSCAM/src/
RUN mkdir /root/DeSCAM/doc
COPY doc  /root/DeSCAM/doc/
RUN mkdir /root/DeSCAM/example
COPY example /root/DeSCAM/example/
RUN mkdir /root/DeSCAM/test
COPY test  /root/DeSCAM/test/
COPY transcript /root/DeSCAM/
COPY CMakeLists.txt /root/DeSCAM/
COPY master /root/
WORKDIR /apps
ENTRYPOINT tail -f /dev/null
CMD [ "/bin/bash" ]

## Container image that runs your code
#FROM ubuntu:18.04
##CMD -it --privileged --cap-add=SYS_ADMIN --device /dev/fuse 
## Copying required folders
#COPY AppImage  /
#COPY install  /
#COPY src  /
#COPY transcript  /
#COPY master  /
#
## Executing Startup Script 
#ENTRYPOINT ["/master"]


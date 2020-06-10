FROM ubuntu:18.04
ENV SHELL /bin/bash
RUN rm /bin/sh && ln -sf /bin/bash /bin/sh
RUN source ~/.profile
RUN export GPG_TTY=$(tty)
RUN apt-get update
RUN apt --assume-yes install git
RUN apt-get --assume-yes install curl
RUN curl -L https://git.io/get_helm.sh | bash
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


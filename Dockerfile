# Container image that runs your code
FROM ubuntu:18.04
#CMD -it --privileged --cap-add=SYS_ADMIN --device /dev/fuse 
# Copying required folders
COPY AppImage  /
COPY install  /
COPY src  /
COPY transcript  /
COPY master  /

# Executing Startup Script 
ENTRYPOINT ["/master"]


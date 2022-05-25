FROM ubuntu:devel
COPY ["setup.sh", "/"]
RUN DEBIAN_FRONTEND=noninteractive chmod +x /setup.sh && /setup.sh && rm /setup.sh
SHELL ["/noclone3", "/bin/bash", "-c"]

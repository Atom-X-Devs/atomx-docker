FROM ubuntu:devel
COPY ["setup.sh", "/"]
RUN DEBIAN_FRONTEND=noninteractive chmod +x /setup.sh && /setup.sh && rm /setup.sh
RUN apt-get update && apt-get install -y sudo
RUN useradd -m -N -s /bin/bash -u 1000 -p 'atomx' atomx-devs && usermod -aG sudo atomx-devs
USER atomx-devs
SHELL ["/noclone3", "/bin/bash", "-c"]

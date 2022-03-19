FROM ubuntu:latest
COPY ["strip.sh", "setup.sh", "remove-gcc.txt", "remove-clang.txt", "/"]
ARG DEBIAN_FRONTEND=noninteractive
RUN chmod +x /setup.sh && /setup.sh

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y grub-pc-bin xorriso && \
    rm -rf /var/lib/apt/lists/*

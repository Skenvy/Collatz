FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt update && \
    apt install -y texlive-latex-base && \
    apt install -y texlive-latex-extra
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

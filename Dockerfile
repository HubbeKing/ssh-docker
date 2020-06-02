FROM alpine:latest

RUN apk add --update --no-cache \
    bash \
    curl \
    mosh \
    openssh-server-pam \
    tzdata

ENV PUID=1000
ENV PGID=1000
ENV USER=hubbe
ENV KUBECTL_VERSION=1.18.3
ENV TZ=Europe/Helsinki

# set timezone
RUN echo ${TZ} > /etc/timezone

# set MOTD
RUN echo "Welcome to hubbe.club!" > /etc/motd

# deactivate short moduli for Diffie-Hellman key exchanges
RUN awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.tmp && mv /etc/ssh/moduli.tmp /etc/ssh/moduli

# install kubectl for exec-ing into other pods
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

RUN addgroup --gid ${PGID} ${USER}
RUN adduser --home /home/${USER} --shell /bin/bash --ingroup ${USER} --uid ${PUID} --system ${USER}

# set PS1 for USER
RUN echo "PS1='[\u@\h \W]\$ '" > /home/${USER}/.bashrc
RUN echo "[[ -f ~/.bashrc ]] && . ~/.bashrc" > /home/${USER}/.bash_profile
RUN chown -R ${USER}:${USER} /home/${USER}

CMD ["/usr/bin/sshd", "-D"]

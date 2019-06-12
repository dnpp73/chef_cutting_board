FROM ubuntu:16.04

# https://docs.docker.com/engine/examples/running_ssh_service/

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo openssh-server ca-certificates curl wget \
    # Cleaning
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && find /usr/share/doc -depth -type f ! -name copyright | xargs rm || true \
    && find /usr/share/doc -empty | xargs rmdir || true \
    && rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* \
    && rm -rf /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

RUN mkdir /var/run/sshd /root/.ssh
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN useradd -m ubuntu
RUN echo 'ubuntu:ubuntu' | chpasswd
RUN usermod -aG sudo ubuntu
RUN chsh -s /bin/bash ubuntu

RUN mkdir /home/ubuntu/.ssh \
    && touch /home/ubuntu/.sudo_as_admin_successful \
    && chown ubuntu:ubuntu /home/ubuntu/.ssh /home/ubuntu/.sudo_as_admin_successful

# no password for sudo
RUN sed -i 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies.
RUN apt-get update \
    # && apt-get install -y --no-install-recommends \
    && apt-get install -y \
       ca-certificates curl gnupg lsb-release \
       apt-utils \
       build-essential \
       locales \
       libffi-dev \
       libssl-dev \
       libyaml-dev \
       python3-dev \
       python3-setuptools \
       python3-pip \
       python3-yaml \
       software-properties-common \
       openssh-server unzip sshpass zsh ufw \
       rsyslog systemd systemd-cron sudo iproute2 \
       openssh-server sudo unzip \
       git ntp mc \
       iptables libip6tc2 libnetfilter-conntrack3 libnfnetlink0 libnftnl11 netbase \
    && apt-get clean \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && mv -v /usr/sbin/ip6tables /usr/sbin/ip6tables--DISABLED-$(date +"%Y-%m-%d--%H-%M") \
    && cp -v /usr/sbin/ip6tables-nft /usr/sbin/ip6tables

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN touch /var/log/auth.log

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

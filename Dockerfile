FROM ubuntu:18.04

WORKDIR /root

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN mkdir /root/.ssh
COPY "id_rsa.pub" /root/.ssh/authorized_keys

RUN mkdir /usr/lib/nimbula
COPY "${PWD}/scripts/zk*" /usr/lib/nimbula/

COPY "${PWD}/scripts" /root

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

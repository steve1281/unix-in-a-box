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

COPY "${PWD}/scripts" /root
# RUN openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes | echo -e "CA\n\n\n\n\n\n"
# CMD ["./sslserver.py &"]
# CMD ["./simpleserver.py &"]


EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

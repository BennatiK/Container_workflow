#Container file to create a swiss army knife within MTE-VOD environment
FROM registry.redhat.io/rhel8/buildah as mediainfo

#copy files to host
COPY repo-script.sh /usr/local/bin/

#installing ssh session manager
RUN /usr/local/bin/repo-script.sh

RUN dnf install -y openssh-server telnet nmap mailx python3 && \
    dnf clean all && \
    rm -rf /var/lib/rpm /usr/share/doc /usr/share/man /var/cache

# 
#    dnf install -y openssh-server telnet nmap s-nail && \
#Change directory
WORKDIR /

RUN mkdir -p /var/run/sshd /root/.ssh && touch /root/.ssh/authorized_keys && chmod 0700 /root/.ssh && chmod 0600 /root/.ssh/authorized_keys \
    && sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin without-password/g' /etc/ssh/sshd_config \
    && echo 'Port 2200' >> /etc/ssh/sshd_config \
    && echo 'AddressFamily inet' >> /etc/ssh/sshd_config \
    && echo '#ListenAddress 0.0.0.0' >> /etc/ssh/sshd_config

#Expose ports for mail
#EXPOSE 25
# update
EXPOSE 2200

#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["sleep", "infinity"]


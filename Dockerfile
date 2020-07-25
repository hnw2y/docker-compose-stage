  
FROM jlphillips/csci3130

LABEL maintainer = "Hannah Williams"

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y \
    gromacs \
    grace \
    dnsutils \
    gromacs-mpich \
    && apt-get clean

COPY start_ssh_server.sh /usr/local/bin/before-notebook.d/start_ssh_server.sh

RUN mkdir /home/jovyan/.ssh
RUN chmod 700 /home/jovyan/.ssh

COPY authorized_keys /home/jovyan/.ssh/.
RUN chmod 644 /home/jovyan/.ssh/authorized_keys

COPY id_rsa /home/jovyan/.ssh/.
RUN chmod 600 /home/jovyan/.ssh/id_rsa

COPY id_rsa.pub /home/jovyan/.ssh/.
RUN chmod 644 /home/jovyan/.ssh/id_rsa.pub

RUN echo -n "* " >> /home/jovyan/.ssh/known_hosts
RUN cat /etc/ssh/ssh_host_ecdsa_key.pub >> /home/jovyan/.ssh/known_hosts
RUN chmod 600 /home/jovyan/.ssh/known_hosts

RUN chown -R jovyan /home/jovyan/.ssh

# CSCI 3130
USER $NB_UID

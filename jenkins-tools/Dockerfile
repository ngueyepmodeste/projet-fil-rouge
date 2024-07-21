FROM centos:centos7.9.2009
LABEL Name="Modeste Ngueyep"
LABEL email="modestengueyep1@gmail.com"

# Configurer une URL de base alternative pour les dépôts CentOS
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo

# Installer les dépendances
RUN yum update -y && \
    yum install -y git initscripts curl java-1.8.0-openjdk java-1.8.0-openjdk-devel unzip which epel-release && \
    yum install -y nginx && \
    yum clean all

# Installer Node.js (Heroku CLI nécessite Node.js)
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - && \
    yum install -y nodejs && \
    npm install -g heroku && \
    yum clean all

# Installer Docker
RUN curl -fsSL https://get.docker.com/ | sh

# Nettoyer les unités systemd inutiles
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ "$i" == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*

VOLUME ["/sys/fs/cgroup"]

# Créer l'utilisateur Jenkins
RUN useradd -m -s /bin/bash jenkins

# Ajouter le dépôt Jenkins et importer la clé GPG
RUN curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.io.key -o /etc/pki/rpm-gpg/RPM-GPG-KEY-jenkins && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-jenkins && \
    echo -e "[jenkins]\nname=Jenkins-stable\nbaseurl=http://pkg.jenkins.io/redhat-stable\ngpgcheck=1\n" > /etc/yum.repos.d/jenkins.repo && \
    yum install -y --nogpgcheck jenkins && \
    yum clean all

# Configurer Jenkins
COPY . /jenkins
RUN sh /jenkins/jenkins-install.sh
RUN cp /jenkins/jenkins.conf /etc/nginx/conf.d/jenkins.conf

# Exposer les ports nécessaires
EXPOSE 80
EXPOSE 8080

# Définir les volumes pour Jenkins
VOLUME /var/lib/jenkins
VOLUME /usr/local/jenkins

# Activer et configurer les services Docker, Nginx et Jenkins
RUN systemctl enable docker && \
    usermod -aG docker jenkins && \
    systemctl enable nginx.service && \
    systemctl enable jenkins

# Définir le point d'entrée
CMD ["/usr/sbin/init"]


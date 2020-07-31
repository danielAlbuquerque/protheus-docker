FROM centos:7

LABEL maintainer "Enderson Maia <endersonmaia@gmail.com>"

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo \
    && yum -y update \
    && yum -y install \
      postgresql \
      postgresql-odbc \
      wget \
    && ACCEPT_EULA=Y yum install -y msodbcsql17 \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN DUMB_INIT_SHA256="37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9" \
    && wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && echo "37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9 */usr/bin/dumb-init" | sha256sum -c - \
    && chmod +x /usr/bin/dumb-init

ADD 20-07-15-DBACCESS_LINUX_X64_BUILD-19.2.1.1.TAR.GZ /opt/totvs/dbaccess64

COPY /build /build

RUN /build/setup.sh

EXPOSE 7890

WORKDIR /opt/totvs/dbaccess64/multi

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/usr/local/bin/my-init.sh", "dbaccess" ]

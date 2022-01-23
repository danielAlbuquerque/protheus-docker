FROM centos:7

LABEL maintainer "Daniel Albuquerque <daniel.alb.querque@gmail.com>"

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

ADD 21-10-08-TOTVS_DBACCESS_BUILD_21.1.1.0_LINUX_X64.TAR.GZ /opt/totvs/dbaccess64

COPY /build /build

RUN /build/setup.sh

EXPOSE 7890

WORKDIR /opt/totvs/dbaccess64/multi

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/usr/local/bin/my-init.sh", "dbaccess" ]

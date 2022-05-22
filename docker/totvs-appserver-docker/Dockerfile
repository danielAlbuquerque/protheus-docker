FROM centos:7

LABEL maintainer "Daniel Albuquerque <daniel.alb.querque@gmail.com>"

RUN yum -y update \
    && yum -y install \
        dmidecode \
        fontconfig \
        glib2 \
        glibc \
        libstdc++ \
        libuuid \
        wget \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN DUMB_INIT_SHA256="37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9" \
    && wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && echo "37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9 */usr/bin/dumb-init" | sha256sum -c - \
    && chmod +x /usr/bin/dumb-init

COPY /build /build

ADD 22-03-15-P12_APPSERVER_BUILD-20.3.0.8_LINUX_X64.TAR.GZ /totvs12/protheus/bin/appserver

RUN /build/setup.sh

EXPOSE 9999

VOLUME ["/totvs12/protheus_data", "/totvs12/protheus/apo/"]

WORKDIR /totvs12/protheus/bin/appserver

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/usr/local/bin/my-init.sh" ]

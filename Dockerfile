#Changed 3.1 to 3.3
#Changed RUN apt-key to curl command from page 
#https://apt.opensips.org/packages.php?os=bullseye
#curl https://apt.opensips.org/opensips-org.gpg -o /usr/share/keyrings/opensips-org.gpg
#echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bullseye 3.3-releases" >/etc/apt/sources.list.d/opensips.list
#echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bullseye cli-nightly" >/etc/apt/sources.list.d/opensips-cli.list

FROM debian:bullseye
LABEL maintainer="Razvan Crainea <razvan@opensips.org>"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.3
ARG OPENSIPS_BUILD=releases

#install basic components
RUN apt-get -y update -qq && apt-get -y install gnupg2 ca-certificates curl apt-utils

#add keyserver, repository
#RUN apt-key adv --fetch-keys https://apt.opensips.org/pubkey.gpg
RUN curl https://apt.opensips.org/opensips-org.gpg -o /usr/share/keyrings/opensips-org.gpg
#RUN echo "deb https://apt.opensips.org buster ${OPENSIPS_VERSION}-${OPENSIPS_BUILD}" >/etc/apt/sources.list.d/opensips.list
RUN echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bullseye 3.3-releases" >/etc/apt/sources.list.d/opensips.list

RUN apt-get -y update -qq && apt-get -y install opensips

#sunitha changed false to true for OPENSIPS_CLI
ARG OPENSIPS_CLI=true
RUN if [ ${OPENSIPS_CLI} = true ]; then \
    echo "deb [signed-by=/usr/share/keyrings/opensips-org.gpg] https://apt.opensips.org bullseye cli-nightly" >/etc/apt/sources.list.d/opensips-cli.list \
&& apt-get -y update -qq && apt-get -y install opensips-cli \
    ;fi

#sunitha added opensips-mysql-module
ARG OPENSIPS_EXTRA_MODULES=opensips-mysql-module
RUN if [ -n "${OPENSIPS_EXTRA_MODULES}" ]; then \
    apt-get -y install ${OPENSIPS_EXTRA_MODULES} \
    ;fi

RUN rm -rf /var/lib/apt/lists/*
RUN sed -i "s/^\(socket\|listen\)=udp.*5060/\1=udp:eth0:5060/g" /etc/opensips/opensips.cfg

EXPOSE 5060/udp

ENTRYPOINT ["/usr/sbin/opensips", "-FE"]

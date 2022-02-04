FROM docker.io/library/wordpress:latest

ADD wp-config.sh /opt/wp-init.sh

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --output /usr/bin/wp \
	&& chmod +X /usr/bin/wp \
	&& chmod 766 /usr/bin/wp

RUN mv /opt/wp-init.sh /usr/bin/wp-init \
	&& chmod +X /usr/bin/wp-init \
	&& chmod 766 /usr/bin/wp-init

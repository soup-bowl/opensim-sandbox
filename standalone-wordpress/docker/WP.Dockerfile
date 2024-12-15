FROM docker.io/library/wordpress:latest

COPY wp-config.sh /opt/wp-init.sh
COPY https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/bin/wp

RUN chmod +X /usr/bin/wp \
    && chmod 766 /usr/bin/wp \
    && mv /opt/wp-init.sh /usr/bin/wp-init \
    && chmod +X /usr/bin/wp-init \
    && chmod 766 /usr/bin/wp-init

FROM amazon/aws-cli:latest

# Clear entrypoint from the base image, otherwise it's always calling the aws CLI
ENTRYPOINT []
CMD ["/bin/bash"]

COPY ./compose/staging/aws/maintenance /usr/local/bin/maintenance
COPY ./compose/staging/postgres/maintenance/_sourced /usr/local/bin/maintenance/_sourced

RUN chmod +x /usr/local/bin/maintenance/*

RUN mv /usr/local/bin/maintenance/* /usr/local/bin \
    && rmdir /usr/local/bin/maintenance

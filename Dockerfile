FROM golang:latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    bash \
    make \
    jq \
    tree \
    tar \
    zip \
 && rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -sf /bin/bash /bin/sh
ENV SHELL=/bin/bash

RUN go get -d github.com/tools/godep && \
    go install github.com/tools/godep && \
    go get -u github.com/golang/lint/golint && \
    go get -u github.com/sanbornm/go-selfupdate && \
    go install github.com/sanbornm/go-selfupdate

RUN echo 'alias ll="ls -al"' >> ~/.bashrc

#
# downloading the latest shuati source code so that it allows to
# run the container without mapping to any local shuati copy
# e.g.
#       docker build -t shuati .
#       docker run --rm -it shuati
#
RUN mkdir -p /go/src/github.com/dockerian
RUN git clone https://github.com/dockerian/shuati /go/src/github.com/dockerian/shuati

ENV PROJECT_DIR $GOPATH/src/github.com/dockerian/shuati
RUN mkdir -p "$PROJECT_DIR"
WORKDIR $PROJECT_DIR

# ENTRYPOINT ["/bin/bash", "-c", "make build"]
CMD ["/bin/bash"]

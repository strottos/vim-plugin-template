FROM tweekmonster/vim-testbed:latest

RUN install_vim -tag v8.0.0027 -build -py

ENV PACKAGES="\
    bash \
    git \
    python \
"
RUN apk --update add $PACKAGES && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN git clone https://github.com/junegunn/vader.vim /vader
RUN mkdir -p /strotter/template
COPY test/vimrc /root/.vimrc
COPY . /strotter/template
WORKDIR /strotter/template

FROM tweekmonster/vim-testbed:latest

RUN apk --update add bash git python py-pip && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*
RUN pip install six

RUN install_vim -tag v8.0.0027 -py -build

RUN git clone https://github.com/junegunn/vader.vim /vader
RUN mkdir -p /strotter/template
COPY test/vimrc /root/.vimrc
COPY . /strotter/template
WORKDIR /strotter/template

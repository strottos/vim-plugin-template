all: build

deps:
	GOPATH=$(shell pwd)/go go get github.com/spf13/cobra/cobra
	GOPATH=$(shell pwd)/go go get github.com/koding/logging
	GOPATH=$(shell pwd)/go go get gopkg.in/ini.v1

build: deps
	GOPATH=$(shell pwd)/go GOBIN=$(shell pwd)/go/bin go install -v -x go/src/echo_server/echo_server.go

clean:
	rm -rf go/pkg/
	rm -rf go/bin/


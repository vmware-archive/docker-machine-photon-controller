default: build

version := "v1.0"
version_description := "Docker Machine Driver Plugin for the Controller"
human_name := "Photon Controller Driver"

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
github_user := "vmware"
project := "github.com/$(github_user)/$(current_dir)"
bin_suffix := ""
driver_bin := "docker-machine-driver-photon"

containerbuild:
	docker build -t $(current_dir) .
	docker run \
		-v $(shell pwd):/go/src/$(project) \
		-e GOOS \
		-e GOARCH \
		-e GO15VENDOREXPERIMENT=1 \
		$(current_dir) \
		make build

containerrelease:
	docker build -t $(current_dir) .
	docker run \
		-v $(shell pwd):/go/src/$(project) \
		-e GOOS \
		-e GOARCH \
		-e GITHUB_TOKEN \
		-e GO15VENDOREXPERIMENT=1 \
		$(current_dir) \
		make release

clean:
	rm bin/docker-machine*

compile:
	GOGC=off CGOENABLED=0 go build -ldflags "-s" -o bin/$(driver_bin)$(BIN_SUFFIX) bin/main.go

print-success:
	@echo
	@echo "Plugin built."
	@echo
	@echo "To use it, either run 'make install' or set your PATH environment variable correctly."

build: compile print-success

cross:
	for os in darwin windows linux; do \
		for arch in amd64; do \
			GOOS=$$os GOARCH=$$arch BIN_SUFFIX=_$$os-$$arch $(MAKE) compile & \
		done; \
	done; \
	wait

install:
	cp bin/$(driver_bin) /usr/local/bin/$(driver_bin)

cleanrelease:
	github-release delete \
		--user $(github_user) \
		--repo $(current_dir) \
		--tag $(version)
	git tag -d $(version)
	git push origin :refs/tags/$(version)

release: cross
	git tag $(version)
	git push --tags
	github-release release \
		--user $(github_user) \
		--repo $(current_dir) \
		--tag $(version) \
		--name $(human_name) \
		--description $(version_description)
	for os in darwin windows linux; do \
		for arch in amd64; do \
			github-release upload \
				--user $(github_user) \
				--repo $(current_dir) \
				--tag $(version) \
				--name bin/$(driver_bin)_$$os-$$arch \
				--file bin/$(driver_bin)_$$os-$$arch; \
		done; \
	done
<!--[metadata]>
+++
title = “Driver Plugin Installation”
description = "Photon Controller driver plugin installation for machine"
keywords = ["machine, Photon Controller, driver"]
+++
<![end-metadata]-->

# Driver Plugin Installation

Following are the step by step instructions for building and installing the driver plugin:

## Getting Started

The requirements to build plugin are:

1.  A running instance of Docker or a Golang 1.6 development environment
2.  The `bash` shell
3.  [Make](https://www.gnu.org/software/make/)

## Local Go development environment

Make sure the source code directory is under a correct directory structure.
Example of cloning and preparing the correct environment `GOPATH`:

    $ mkdir docker-machine-driver
    $ cd docker-machine-driver
    $ export GOPATH="$PWD"
    $ go get github.com/vmware/docker-machine-photon-controller
    $ cd src/github.com/vmware/docker-machine-photon-controller

If you want to use your existing workspace, make sure your `GOPATH` is set to
the directory that contains your `src` directory, e.g.:

    $ export GOPATH=/home/yourname/work
    $ mkdir -p $GOPATH/src/github.com/vmware
    $ cd $GOPATH/src/github.com/vmware && git clone git@github.com:vmware/docker-machine-photon-controller.git
    $ cd docker-machine-photon-controller        

At this point, simply run:

    $ make build

## Built binary

After the build is complete a `bin/docker-machine-driver-photon` binary will be created.

You may call:

    $ make clean

to clean-up build results.

## Install Plugin

After the build is successful run the following to install the plugin to be used with docker-machine:

    $ make install

It will copy the binary to the path: /usr/local/bin to be used with docker-machine.

To test that the installation is successful simply run the following command:

    $ docker-machine create -d photon

It should display the following output:

Usage: docker-machine create [OPTIONS] [arg...]

Create a machine

Description:

   Run 'docker-machine create --driver name' to include the create flags for that driver in the help text.

Options:
   
   --driver, -d "none"											Driver to create machine with.

   --engine-env [--engine-env option --engine-env option]						Specify environment variables to set in the engine

   --engine-insecure-registry [--engine-insecure-registry option --engine-insecure-registry option]	Specify insecure registries to allow with the created engine

   --engine-install-url "https://get.docker.com"							Custom URL to use for engine installation [$MACHINE_DOCKER_INSTALL_URL]

   --engine-label [--engine-label option --engine-label option]						Specify labels for the created engine

   --engine-opt [--engine-opt option --engine-opt option]						Specify arbitrary flags to include with the created engine in the form flag=value

   --engine-registry-mirror [--engine-registry-mirror option --engine-registry-mirror option]		Specify registry mirrors to use

   --engine-storage-driver 										Specify a storage driver to use with the engine

   --photon-bootdisksize "2"										Boot disk size in GB [$PHOTON_BOOT_DISK_SIZE]

   --photon-diskflavor 											Disk flavor name [$PHOTON_DISK_FLAVOR]

   --photon-diskname "boot-disk"									Disk name [$PHOTON_DISK_NAME]

   --photon-endpoint 											Photon Controller endpoint in format: http://<ip address>:<port> [$PHOTON_ENDPOINT]

   --photon-image 											Image Id [$PHOTON_IMAGE]

   --photon-iso-path 											Path to ISO image with cloud-init data. Mutually exclusive with --photon-ssh-user-password [$PHOTON_ISO_PATH]

   --photon-network 											Network machine needs to connect [$PHOTON_NETWORK]

   --photon-project 											Project Id [$PHOTON_PROJECT]

   --photon-ssh-user "docker"										SSH user [$PHOTON_SSH_USER]

   --photon-ssh-user-password 										SSH User Password. Mutually exclusive with --photon-iso-path [$PHOTON_SSH_USER_PASSWORD]

   --photon-vmflavor 											VM flavor name [$PHOTON_VM_FLAVOR]

   --swarm												Configure Machine with Swarm

   --swarm-addr 											addr to advertise for Swarm (default: detect and use the machine IP)

   --swarm-discovery 											Discovery service to use with Swarm

   --swarm-host "tcp://0.0.0.0:3376"									ip/socket to listen on for Swarm master

   --swarm-image "swarm:latest"										Specify Docker image to use for Swarm [$MACHINE_SWARM_IMAGE]

   --swarm-master											Configure Machine to be a Swarm master

   --swarm-opt [--swarm-opt option --swarm-opt option]							Define arbitrary flags for swarm

   --swarm-strategy "spread"										Define a default scheduling strategy for Swarm

   --tls-san [--tls-san option --tls-san option]							Support extra SANs for TLS certs

Error: No machine name specified

## List of all targets

### High-level targets

    $ make clean
    $ make build
    $ make install

### Advanced build targets

Build for all supported OSes and architectures (binaries will be in the `bin` project subfolder):

    $ make build cross

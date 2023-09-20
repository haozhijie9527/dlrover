#!/bin/bash

set -e

#K8S_VERSION=$1
#curl -sSLo envtest-bins.tar.gz "https://go.kubebuilder.io/\
#test-tools/${K8S_VERSION}/$(go env GOOS)/$(go env GOARCH)"

mkdir /usr/local/kubebuilder
tar -C /usr/local/kubebuilder --strip-components=1 -zvxf kubebuilder-tools-1.19.2-linux-amd64.tar.gz
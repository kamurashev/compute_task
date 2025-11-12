#!/usr/bin/env bash

#SDKMann is a dependency
source "$HOME/.sdkman/bin/sdkman-init.sh"

#install and apply Java to current session
SDK_JAVA_VERSION_ID=${1:-20.0.1-oracle}
sdk install java "$SDK_JAVA_VERSION_ID"
sdk use java "$SDK_JAVA_VERSION_ID"
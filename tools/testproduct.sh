#!/bin/bash
version=`git describe --tags`
version=${version#v}
installer -pkg "../build/Release/VisualJSON $version.pkg" -target '/'
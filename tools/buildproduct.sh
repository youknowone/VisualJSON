#!/bin/bash
version=`git describe --tags`
version=${version#v}
rm ../build/Release/*.app/Contents/Info.plist
cd ..
xcodebuild -target 'VisualJSON' -configuration 'Release' &&
cd build/Release
productbuild --component "VisualJSON.app" '/Applications' --sign "3rd Party Mac Developer Installer: 3rddev Inc." "VisualJSON $version.pkg"

#!/bin/bash

# If tag is 'appstore1.2', set this 'appstore'
# If tag is 'v1.3.1', set this 'v'
tagprefix='v'

# Deploy configuration name
configuration='Release'

# Target name
# If your project have applicaiton target name 'YourApp', set this 'YourApp'
target='VisualJSON'

# Application name
# If your app name is not same to target name, change this.
# If you set this 'MyApp', output is 'MyApp.app' and 'MyApp.pkg'
appname="$target"

# Codesign
# You need '3rd Party Mac Developer Installer: Company Name' codesign to deploy your app to appstore
#codesign="3rd Party Mac Developer Installer"
codesign='3rd Party Mac Developer Installer: 3rddev Inc.'


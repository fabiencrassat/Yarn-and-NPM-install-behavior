#!/usr/bin/env bash

#### FUNCTIONS ####

removePackageLock() {
  rm -f package-lock.json
}
removeYarnLock() {
  rm -f yarn-lock.json
}
echoTitle() {
  echo
  echo ----------------------------
  echo $1
  echo
}


#### MAIN ####

removePackageLock
removeYarnLock
cp assets/package-init.json package.json

# YARN installation
# NPM does not know YARN but the opposite is not true, so we begin with it.
echoTitle "Install with YARN the lodash version 4.16.2"
removePackageLock
yarn install
echoTitle "Check the versions"
yarn list --pattern lodash

# NPM installation
echoTitle "Install with NPM the lodash version 4.16.2"
npm install
echoTitle "Check the versions"
npm list lodash

# Change package.json dependencies
echoTitle "Change to install version ~4.16.2 (patch can change)"
cp assets/package-newDep.json package.json

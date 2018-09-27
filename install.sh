#!/usr/bin/env bash

#### FUNCTIONS ####

echoTitle() {
  echo
  echo ----------------------------
  echo $1
  echo
}
removePackageLock() {
  rm -f package-lock.json
}
removeYarnLock() {
  rm -f yarn-lock.json
}
getLodashVersion() {
  file=node_modules/lodash/package.json
  while read line; do
    if [[ $line =~ \"version\": ]] ; then echo $line; fi
  done < "$file"
}

#### MAIN ####

# Initialisation
removePackageLock
removeYarnLock
cp assets/package-init.json package.json

# YARN installation
# NPM does not know YARN but the opposite is not true, so we begin with it.
echoTitle "Install with YARN the lodash version 4.16.2"
removePackageLock
yarn install
echoTitle "Check the versions = 4.16.2"
yarn list --pattern lodash
getLodashVersion

# NPM installation
echoTitle "Install with NPM the lodash version 4.16.2"
npm install
echoTitle "Check the versions = 4.16.2"
npm list lodash
getLodashVersion

# Change package.json dependencies
echoTitle "Change to install version ~4.16.2 (patch can change)"
cp assets/package-newDep.json package.json

# YARN installation
# It will take the last pach available, at this time 4.16.6
# So it is looking at package.json, not yarn.lock
echoTitle "Install with YARN the lodash version ~4.16.2"
yarn install
echoTitle "Check the versions = 4.16.6 (should be)"
yarn list --pattern lodash
getLodashVersion

# NPM installation
# It will take the package-lock.json version,so 4.16.2
echoTitle "Install with NPM the lodash version ~4.16.2"
npm install
echoTitle "Check the versions = 4.16.2"
npm list lodash
getLodashVersion

exit 0

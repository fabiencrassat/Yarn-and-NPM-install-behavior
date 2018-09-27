#!/usr/bin/env bash

#### FUNCTIONS ####

echoHeader() {
  echo ============================
  echo $1
  echo
}
echoTitle() {
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
  echoTitle "$2"

  if [ $1 = "yarn" ]; then
    yarn list --pattern lodash
  elif [ $1 = "npm" ]; then
    npm list lodash
  else
    echo "wrong args" && exit 1
  fi

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
echo 
echoHeader "YARN installation"
# NPM does not know YARN but the opposite is not true, so we begin with it.
echoTitle "Install the lodash version 4.16.2"
removePackageLock
yarn install
echo 
getLodashVersion "yarn" "The version MUST BE 4.16.2"

# NPM installation
echo 
echoHeader "NPM installation"
echoTitle "Install the lodash version 4.16.2"
npm install
echo 
getLodashVersion "npm" "The version MUST BE 4.16.2"

# Installation behavior
echo 
echoHeader "Installation behavior"
# Change package.json dependencies
echoTitle "Change to install version ~4.16.2 (patch can change)"
cp assets/package-newDep.json package.json

# YARN installation
echoHeader "YARN installation"
# It will take the last pach available, at this time 4.16.6
# So it is looking at package.json, not yarn.lock
echoTitle "Install the lodash version ~4.16.2"
yarn install
echo 
getLodashVersion "yarn" "The version SHOULD BE 4.16.6"

# NPM installation
echo 
echoHeader "NPM installation"
# It will take the package-lock.json version,so 4.16.2
echoTitle "Install the lodash version ~4.16.2"
npm install
echo 
getLodashVersion "npm" "The version MUST BE 4.16.2"

exit 0

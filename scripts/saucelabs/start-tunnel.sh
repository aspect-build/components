#!/bin/bash

set -e -o pipefail

case $(uname) in
  Darwin*) tunnelFileName="sc-4.8.2-osx.zip" ;;
  *) tunnelFileName="sc-4.8.2-linux.tar.gz" ;;
esac
tunnelUrl="https://saucelabs.com/downloads/${tunnelFileName}"

tunnelTmpDir="/tmp/material-saucelabs"
tunnelReadyFile="${tunnelTmpDir}/readyfile"
tunnelPidFile="${tunnelTmpDir}/pidfile"

# Cleanup and create the folder structure for the tunnel connector.
rm -rf ${tunnelTmpDir}
mkdir -p ${tunnelTmpDir}

# Go into the temporary tunnel directory.
cd ${tunnelTmpDir}

# Download the saucelabs connect binaries.
echo "Downloading sauce-connect ${tunnelFileName} ..."
curl ${tunnelUrl} -o ${tunnelFileName} 2> /dev/null 1> /dev/null

# Extract the saucelabs connect binaries from the tarball.
if [[ $tunnelFileName == *"tar"* ]]; then
  mkdir -p sauce-connect
  tar --extract --file=${tunnelFileName} --strip-components=1 --directory=sauce-connect > /dev/null
else
  unzip ${tunnelFileName}
  mv ${tunnelFileName%.*} sauce-connect
fi

# Cleanup the downloaded file
rm ${tunnelFileName}

# Command arguments that will be passed to sauce-connect.
sauceArgs="--readyfile ${tunnelReadyFile} --pidfile ${tunnelPidFile}"

if [ ! -z "${SAUCE_TUNNEL_IDENTIFIER}" ]; then
  sauceArgs="${sauceArgs} --tunnel-identifier ${SAUCE_TUNNEL_IDENTIFIER}"
fi

echo "Starting Sauce Connect in the background. Passed arguments: ${sauceArgs}"

sauce-connect/bin/sc -u ${SAUCE_USERNAME} -k ${SAUCE_ACCESS_KEY} ${sauceArgs}

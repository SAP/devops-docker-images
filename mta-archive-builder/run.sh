#/bin/bash

export NODE_BUILD_ARTIFACT=node/dummy.mtar

docker build -t mta . || { echo "[ERROR] Failed to build mta docker image."; exit 1; }
cd test
docker run -it --rm -v `pwd`/node:/project mta mtaBuild --build-target NEO --mtar ${NODE_BUILD_ARTIFACT} build

[ $? != 0 ] && { echo "Cannot run mta docker image."; exit 1; }

[ -f "${NODE_BUILD_ARTIFACT}" ] || { echo "Expected build result \"${NODE_BUILD_ARTIFACT}\" not found."; exit 1; }

cd -

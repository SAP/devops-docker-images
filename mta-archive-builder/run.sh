#/bin/bash

export BUILD_ARTIFACT=dummy.mtar
export NODE_TEST_FOLDER=test/node

docker build -t mta . || { echo "[ERROR] Failed to build mta docker image."; exit 1; }

docker run -it --rm -v `pwd`/${NODE_TEST_FOLDER}:/project mta mtaBuild --build-target NEO --mtar ${BUILD_ARTIFACT} build

[ $? != 0 ] && { echo "Cannot run mta docker image."; exit 1; }

[ -f "${NODE_TEST_FOLDER}/${BUILD_ARTIFACT}" ] || { echo "Expected build result \"${NODE_TEST_FOLDER}/${BUILD_ARTIFACT}\" not found."; exit 1; }

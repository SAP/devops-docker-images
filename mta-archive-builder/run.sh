#/bin/bash

export BUILD_ARTIFACT=dummy.mtar

docker build -t mta . || { echo "[ERROR] Failed to build mta docker image."; exit 1; }
cd test
docker run -it --rm -v `pwd`:/project mta mtaBuild --build-target NEO --mtar ${BUILD_ARTIFACT} build

[ $? != 0 ] && { echo "Cannot run mta docker image."; exit 1; }

[ -f "${BUILD_ARTIFACT}" ] || { echo "Expected build result \"${BUILD_ARTIFACT}\" not found."; exit 1; }

cd -

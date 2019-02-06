#/bin/bash

export BUILD_ARTIFACT=dummy.mtar
export NODE_TEST_FOLDER=test/node
export MAVEN_TEST_FOLDER=test/maven

docker build -t mta-archive-builder . || { echo "[ERROR] Failed to build mta-archive-builder image."; exit 1; }

docker run -it --rm -v `pwd`/${NODE_TEST_FOLDER}:/project mta-archive-builder mtaBuild --build-target NEO --mtar ${BUILD_ARTIFACT} build
[ $? != 0 ] && { echo "Cannot run mta-archive-builder image."; exit 1; }
[ -f "${NODE_TEST_FOLDER}/${BUILD_ARTIFACT}" ] || { echo "Expected build result \"${NODE_TEST_FOLDER}/${BUILD_ARTIFACT}\" not found."; exit 1; }

docker run -it --rm -v `pwd`/${MAVEN_TEST_FOLDER}:/project mta-archive-builder mtaBuild --build-target NEO --mtar ${BUILD_ARTIFACT} build
[ $? != 0 ] && { echo "Cannot run mta-archive-builder image."; exit 1; }
[ -f "${MAVEN_TEST_FOLDER}/${BUILD_ARTIFACT}" ] || { echo "Expected build result \"${MAVEN_TEST_FOLDER}/${BUILD_ARTIFACT}\" not found."; exit 1; }

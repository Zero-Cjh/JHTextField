#!/bin/sh

script_dir="$( cd "$( dirname "$0"  )" && pwd  )"

WORKSPACE_NAME="JHTextField"
PROJECT_NAME=$WORKSPACE_NAME

FRAMEWORK_NAME="JHTextField"
FRAMEWORK_PATH=$script_dir/'Framework'

TEMP_BUILD_PATH=$script_dir/"Build"
FRAMEWORK_BUILD_OS_PATH=$TEMP_BUILD_PATH/'Release-iphoneos'
FRAMEWORK_BUILD_SIMULATOR_PATH=$TEMP_BUILD_PATH/'Release-iphonesimulator'
FRAMEWORK_OS_PATH=$FRAMEWORK_BUILD_OS_PATH/$FRAMEWORK_NAME.framework
FRAMEWORK_SIMULATOR_PATH=$FRAMEWORK_BUILD_SIMULATOR_PATH/$FRAMEWORK_NAME.framework

function buildClean() {
    xcodebuild clean -target ${FRAMEWORK_NAME}
}

function buildOS() {
    xcodebuild -target ${FRAMEWORK_NAME} \
    ONLY_ACTIVE_ARCH=NO \
    -configuration 'Release' \
    -sdk iphoneos \
    SYMROOT=${TEMP_BUILD_PATH}
}

function buildSimulator() {
    xcodebuild -target ${FRAMEWORK_NAME} \
    ONLY_ACTIVE_ARCH=NO \
    -configuration 'Release' \
    -sdk iphonesimulator \
    SYMROOT=${TEMP_BUILD_PATH}
}

function lipoCreate() {
    lipo -remove arm64 "$FRAMEWORK_SIMULATOR_PATH/$FRAMEWORK_NAME" -output "$FRAMEWORK_SIMULATOR_PATH/$FRAMEWORK_NAME"
    lipo -create "$FRAMEWORK_OS_PATH/$FRAMEWORK_NAME" "$FRAMEWORK_SIMULATOR_PATH/$FRAMEWORK_NAME" -output "$FRAMEWORK_OS_PATH/$FRAMEWORK_NAME"
    cp -rf "$FRAMEWORK_SIMULATOR_PATH/Modules" "$FRAMEWORK_OS_PATH"
    rm -rf $FRAMEWORK_PATH
    mkdir $FRAMEWORK_PATH
    cp -rf $FRAMEWORK_OS_PATH $FRAMEWORK_PATH
    rm -rf $TEMP_BUILD_PATH
    open $FRAMEWORK_PATH
}

buildClean
buildOS
buildSimulator
lipoCreate

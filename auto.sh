#!/bin/sh

script_dir="$( cd "$( dirname "$0"  )" && pwd  )"

WORKSPACE_NAME="JHTextField"
PROJECT_NAME=$WORKSPACE_NAME

FRAMEWORK_NAME="JHTextField"
FRAMEWORK_PATH=$script_dir/'Framework'
FRAMEWORK_BUILD_OS_PATH=$FRAMEWORK_PATH/'Release-iphoneos'
FRAMEWORK_BUILD_SIMULATOR_PATH=$FRAMEWORK_PATH/'Release-iphonesimulator'
FRAMEWORK_OS_PATH=$FRAMEWORK_BUILD_OS_PATH/$FRAMEWORK_NAME.framework
FRAMEWORK_SIMULATOR_PATH=$FRAMEWORK_BUILD_SIMULATOR_PATH/$FRAMEWORK_NAME.framework

function buildClean() {
    xcodebuild clean -workspace ${WORKSPACE_NAME}.xcworkspace \
    -scheme ${PROJECT_NAME}
}

function buildOS() {
    xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace \
    -scheme ${PROJECT_NAME} \
    ONLY_ACTIVE_ARCH=NO \
    -configuration 'Release' \
    -sdk iphoneos \
    SYMROOT=${FRAMEWORK_PATH}
    
    buildClean
}

function buildSimulator() {
    xcodebuild -workspace ${WORKSPACE_NAME}.xcworkspace \
    -scheme ${PROJECT_NAME} \
    ONLY_ACTIVE_ARCH=NO \
    -configuration 'Release' \
    -sdk iphonesimulator \
    SYMROOT=${FRAMEWORK_PATH}
    
    buildClean
}

function lipoCreate() {
    lipo -remove arm64 "$FRAMEWORK_SIMULATOR_PATH/$FRAMEWORK_NAME" -output "$FRAMEWORK_SIMULATOR_PATH/$FRAMEWORK_NAME"
    lipo -create "$FRAMEWORK_OS_PATH/$FRAMEWORK_NAME" "$FRAMEWORK_SIMULATOR_PATH/$FRAMEWORK_NAME" -output "$FRAMEWORK_OS_PATH/$FRAMEWORK_NAME"
    cp -rf "$FRAMEWORK_SIMULATOR_PATH/Modules" "$FRAMEWORK_OS_PATH"
    cp -rf $FRAMEWORK_OS_PATH $FRAMEWORK_PATH
    rm -rf $FRAMEWORK_BUILD_OS_PATH
    rm -rf $FRAMEWORK_BUILD_SIMULATOR_PATH
}
buildOS
buildSimulator
lipoCreate

open $FRAMEWORK_PATH

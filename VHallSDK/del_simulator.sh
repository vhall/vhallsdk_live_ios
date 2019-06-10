#!/bin/sh
#


SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)
cd $SCRIPT_DIR

echo "|-------------------------------  Del Start    ---------------------------|"

lipo -remove x86_64 ./VhallLiveBaseApi.framework/VhallLiveBaseApi -o ./VhallLiveBaseApi.framework/VhallLiveBaseApi

lipo -remove x86_64 ./VHallInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic -o ./VHallInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic
lipo -remove i386   ./VHallInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic -o ./VHallInteractive/VhallSignalingDynamic.framework/VhallSignalingDynamic

lipo -remove x86_64 ./VHallInteractive/WebRTC.framework/WebRTC -o ./VHallInteractive/WebRTC.framework/WebRTC

echo "|-------------------------------Del Successful----------------------------|"

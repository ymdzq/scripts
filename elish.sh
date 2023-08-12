#!/bin/sh

# Basic build function
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

# Repo sync
repo sync --no-tags --no-clone-bundle -j$(nproc --all)
sed -i s/build-user/ymdzq/g build/_setup_env.sh
sed -i s/build-host/ofrp/g build/_setup_env.sh
# Build elish
# clean build?
if [ "$1" = "-c" -o "$1" = "--clean" ]; then
   echo "clean build!"
   [ -d out ] && rm -rf out;
   BUILD_CONFIG=kernel/msm-4.19/build.config.xiaomi.elish COMPILER=gcc BUILD_KERNEL=1 build/build.sh
else
   echo "dirty build!"
   BUILD_CONFIG=kernel/msm-4.19/build.config.xiaomi.elish COMPILER=gcc BUILD_KERNEL=1 SKIP_MRPROPER=1 build/build.sh
fi

# Create zip
cp out/android-4.19-stable/dist/Image ak3/
cat out/android-4.19-stable/dist/*.dtb > ak3/dtb
#cp out/android-4.19-stable/dist/dtbo.img ak3/
rm ak3/*.zip
cd ak3/ && zip -r9 eva-elish-$(/bin/date -u '+%d%m%Y%I%M').zip * -x .git README.md ./*/placeholder
cd ../

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Full build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"

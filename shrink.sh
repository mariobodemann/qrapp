#!/usr/bin/env bash
echo 'building'
./gradlew clean assembleDebug

echo
echo 'fetching debug build'.
ls -lah app/build/outputs/apk/debug/app-debug.apk
cp app/build/outputs/apk/debug/app-debug.apk initial.apk

echo
echo 'unpacking / shrinking / packing'
cp initial.apk compressed.apk
unzip compressed.apk lib/arm64-v8a/libqr.so
zip -9 -m compressed.apk lib/arm64-v8a/libqr.so
advzip --shrink-insane --iter=256 --recompress compressed.apk
$ANDROID_HOME/build-tools/30.0.3/zipalign -f 1 compressed.apk aligned.apk

echo
echo 'resigning'
$ANDROID_HOME/build-tools/30.0.3/apksigner sign \
        --verbose \
        --in aligned.apk \
        --out signed.apk \
        --ks release.jks \
        --ks-pass pass:qqqqqq \
        --v1-signing-enabled true \
        --v2-signing-enabled false \
        --v3-signing-enabled false \
        --v4-signing-enabled false

echo
echo 'delete old install on phone'
adb uninstall app.qr
adb install -t signed.apk

echo
echo 'RESULTS:'
ls -la -S | grep .apk$

echo
echo 'trying qr code'
qrencode -8 -r signed.apk -o Qr.app.png

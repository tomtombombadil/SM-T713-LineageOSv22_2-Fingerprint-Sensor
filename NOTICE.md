# Notice

## Third-party binaries

The following files in `src/flashable/files/` (and inside the TWRP zips) were extracted, unmodified, from the official LineageOS 22.2 build `lineage-22.2-20261111-nightly-gts4lvwifi-signed.zip` (Samsung Galaxy Tab S5e), downloaded from download.lineageos.org:

- `bin/hw/android.hardware.biometrics.fingerprint-service.samsung`
- `bin/hw/android.hardware.gatekeeper@1.0-service`
- `lib64/hw/android.hardware.gatekeeper@1.0-impl.so`
- `lib64/android.hardware.gatekeeper@1.0.so`
- `lib64/android.hardware.biometrics.common-V4-ndk.so`
- `lib64/android.hardware.biometrics.common.util.so`
- `lib64/android.hardware.biometrics.fingerprint-V4-ndk.so`
- `lib64/android.hardware.keymaster-V4-ndk.so`
- `etc/vintf/manifest/android.hardware.biometrics.fingerprint-service.samsung.xml`
- `etc/permissions/android.hardware.fingerprint.xml`

They are built from the Android Open Source Project and LineageOS source code, which is licensed under the Apache License, Version 2.0:

- https://github.com/LineageOS/android_hardware_samsung (fingerprint service)
- https://android.googlesource.com/platform/hardware/interfaces (gatekeeper service and interface libraries)
- https://www.apache.org/licenses/LICENSE-2.0

## Samsung components

No Samsung proprietary files are included in this repository. The package uses Samsung components that are already part of retiredtab's LineageOS 22.2 ROM for the SM-T713 (`libbauthserver.so`, `libbauthtzcommon.so`, `gatekeeper.msm8952.so`, and the TrustZone apps on the firmware partition).

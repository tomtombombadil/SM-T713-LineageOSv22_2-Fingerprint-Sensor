# Fingerprint sensor for the Samsung Galaxy Tab S2 SM-T713 on LineageOS 22.2

This package makes the home-button fingerprint sensor work on the **Samsung Galaxy Tab S2 8.0 (SM-T713, codename `gts28vewifi`)** running **retiredtab's unofficial LineageOS 22.2 (Android 15)**.

With it installed you can:

- enroll fingerprints in **Settings → Security → Fingerprint**
- unlock the lock screen with your fingerprint
- use fingerprint login inside apps that use Android's standard biometric prompt (tested with Aegis Authenticator, which uses a keystore-protected key the same way password managers do)

SELinux stays **enforcing**.

> **This is an unofficial, community-made hack. It is not supported by retiredtab or LineageOS. Please do not ask retiredtab for help with it.**

---

# ⚠️ READ THIS BEFORE YOU UPDATE LINEAGEOS ⚠️

## BEFORE YOU UPDATE TO ANY NEW LINEAGEOS RELEASE — FROM RETIREDTAB OR FROM ANYONE ELSE — YOU MUST FIRST REMOVE ALL OF YOUR LOCK SCREEN SECURITY:

## 1. DELETE EVERY FINGERPRINT
## 2. SET THE SCREEN LOCK TO "NONE" (NO PIN, NO PATTERN, NO PASSWORD)

## IF YOU SKIP THIS, YOU WILL MOST LIKELY BE LOCKED OUT OF YOUR TABLET AND HAVE TO WIPE IT (FORMAT DATA), LOSING EVERYTHING ON IT.

**Why:** this package replaces the ROM's *software* gatekeeper (the part of Android that checks your PIN) with the tablet's *TrustZone* gatekeeper. A PIN created with one cannot be read by the other. Any LineageOS update, any other ROM, or uninstalling this package puts the software gatekeeper back, and it will not recognise the PIN you set while this package was installed.

The same rule applies **before uninstalling this package** and **before flashing any other ROM**.

---

## Risks — please read

By installing this you accept that:

- **You can lose all data on the tablet.** If anything goes wrong while a PIN is set, the only way back in may be TWRP → Wipe → Format Data.
- **The tablet may fail to boot** (stuck on the boot animation). Recovery steps are below, but you need TWRP and some comfort with it.
- **It changes the security of your device.** It swaps the PIN-checking component, adds a fingerprint service, and adds SELinux rules through Magisk. It requires root (Magisk). It has had far less review than anything official.
- **It contains binaries built for a different device.** The fingerprint and gatekeeper services were taken from the official LineageOS 22.2 build for the Galaxy Tab S5e (`gts4lvwifi`). They are standard LineageOS/AOSP programs, but they were not built for this tablet.
- **It was tested on one tablet**, with retiredtab's build `lineage-22.2-20260909-UNOFFICIAL-gts28vewifi`. Other builds may behave differently.
- **There is no warranty.** You use it entirely at your own risk.

If you are not comfortable with TWRP, Magisk, and possibly wiping your tablet, **do not install this**.

---

## Requirements

- Samsung Galaxy Tab S2 8.0 **SM-T713** (`gts28vewifi`) — no other model. The installer refuses to run on anything else.
- **retiredtab's LineageOS 22.2** (Android 15) already installed and set up. The installer refuses to run on other Android versions.
- **TWRP** recovery (tested with 3.6.2_9-0).
- **Magisk** installed and working (root).
- A backup of anything on the tablet you care about, stored **off** the tablet.

A PC with ADB is not required to install, but it is useful for checking that everything worked.

---

## Downloads

All files are in the [`downloads`](downloads) folder.

| File | What it is | How to install |
|---|---|---|
| `T713-fingerprint-v4-install.zip` | The fingerprint package | Flash in TWRP |
| `T713-fingerprint-v4-uninstall.zip` | Removes the package and restores the ROM's original files | Flash in TWRP |
| `T713-fingerprint-selinux-rules-magisk.zip` | Magisk module with the SELinux rules the package needs. **Required.** | Magisk app → Modules → Install from storage |
| `T713-recovery-permissive-magisk.zip` | Safety-net Magisk module that turns SELinux to permissive. **Install it, then switch it off.** Only used to rescue a tablet that won't boot. | Magisk app → Modules → Install from storage |

SHA-256 checksums:

```
3e3fc01efff5fb13fb50769c5ce0b1a828342db300b4d0710b7da41f151842dc  T713-fingerprint-v4-install.zip
57aae565506520e1431f1daf828486b1e7219f8909b414839397d0ba093ff0b8  T713-fingerprint-v4-uninstall.zip
23f024926265abcb2a8b6c7343f54e859979f665b8d696412cfa4250a8d96a9e  T713-fingerprint-selinux-rules-magisk.zip
1a2bb3f67e329576d1e21f08f0a12c1879b767012a6fee5ab577d2648b1b5795  T713-recovery-permissive-magisk.zip
```

To check a download on Windows, open Command Prompt in the folder and run, for example:

```
certutil -hashfile T713-fingerprint-v4-install.zip SHA256
```

Copy all four zips to the tablet's **microSD card** (TWRP can always read it). Internal storage works too if TWRP can see it.

---

## Installation

### Step 1 — Back up

1. Copy anything important off the tablet.
2. Boot TWRP (power off, then hold **Volume Up + Home + Power**), go to **Backup**, select **System** and **Boot**, choose the microSD card, and swipe. Reboot to System.

### Step 2 — Remove the screen lock

Go to **Settings → Security → Screen lock** and choose **None**. If you have any fingerprints, delete them.

> **Do not skip this.** Your current PIN belongs to the ROM's software gatekeeper and will stop working once the package is installed.

### Step 3 — Install the two Magisk modules

1. Open **Magisk → Modules → Install from storage** and choose `T713-fingerprint-selinux-rules-magisk.zip`.
2. Do the same for `T713-recovery-permissive-magisk.zip`.
3. In the Modules list, **switch OFF** "T713 fingerprint test - permissive SELinux". Leave it installed; it is your rescue tool (see Troubleshooting).
4. Make sure **"T713 fingerprint SELinux rules" is ON**.
5. Do **not** reboot to System yet.

> The SELinux rules module must be installed **before** the package. Without it the tablet will hang on the boot animation.

### Step 4 — Flash the package in TWRP

1. Reboot to TWRP (power off, then **Volume Up + Home + Power**).
2. **Install** → choose `T713-fingerprint-v4-install.zip` → swipe.
3. The installer checks that it is running on an SM-T713 with Android 15, disables the software gatekeeper (it keeps a backup), and copies the new files. It should end with **"Done. Reboot to System."**
4. Tap **Reboot System**.

### Step 5 — Set a PIN and enroll your fingerprint

1. When the tablet has booted, go to **Settings → Security → Screen lock** and set a **PIN** (or pattern/password).
2. Lock and unlock with the PIN a couple of times, then **reboot** and unlock with the PIN again. This confirms the TrustZone gatekeeper is working.
3. Go to **Settings → Security → Fingerprint** and add a fingerprint. Press the home button repeatedly as prompted until the circle fills.
   - If you get **"Can't complete fingerprint setup. Something went wrong"** on the very first attempt, just try again. The first attempt after a reboot sometimes fails; later attempts work.
4. Lock the tablet and unlock it with your finger.

### Step 6 (optional) — Confirm SELinux is enforcing

With USB debugging on and the tablet connected to a PC with ADB:

```
adb shell getenforce
```

It should print `Enforcing`.

You're done.

---

## Normal behaviour

- **After every reboot, the first unlock needs your PIN.** This is standard Android behaviour on every device. After that, the fingerprint works.
- **Maximum 4 fingerprints.** That is Samsung's limit for this sensor.
- **Main user only.** Fingerprints work for the tablet's main (owner) user. Secondary user profiles are not supported.

---

## Updating LineageOS

# ⚠️ REMOVE ALL FINGERPRINTS AND SET THE SCREEN LOCK TO "NONE" FIRST ⚠️

This applies to **every** LineageOS update — retiredtab's monthly builds, or any other ROM.

1. **Settings → Security → Fingerprint**: delete every fingerprint.
2. **Settings → Security → Screen lock**: choose **None**.
3. Boot TWRP and flash the LineageOS update as usual. The update overwrites the system and boot partitions, which removes both this package and Magisk.
4. Get Magisk back **before** you put this package back. Without Magisk, the SELinux rules module isn't loaded, and the tablet will hang on the boot animation. Either:
   - **(a)** in the same TWRP session, flash Magisk, then flash `T713-fingerprint-v4-install.zip`, then reboot; or
   - **(b)** reboot to System *without* flashing this package, reinstall Magisk the way you normally do, check that the two Magisk modules are still listed (they're kept on `/data`), then boot TWRP and flash `T713-fingerprint-v4-install.zip`.
5. Reboot to System, set your PIN, and enroll your fingerprints again.

The installer only runs on Android 15. If a future release moves to a newer Android version, this package will not install, and you should keep the screen lock at None.

---

## Uninstalling

1. **Delete all fingerprints** and set the **screen lock to None**. (Same reason as above.)
2. Boot TWRP and flash `T713-fingerprint-v4-uninstall.zip`. It removes the package's files and restores the ROM's original software gatekeeper.
3. Reboot to System.
4. In **Magisk → Modules**, remove "T713 fingerprint SELinux rules" and "T713 fingerprint test - permissive SELinux", then reboot.
5. Set your PIN again.

The fingerprint data folder (`/data/biometrics`) is left behind. It is harmless.

---

## Troubleshooting

### Stuck on the boot animation right after installing

You have no PIN set at this point, so this is safe to undo:

1. Force the tablet off and into TWRP: hold **Volume Down + Home + Power** for about 10 seconds until the screen goes black, then immediately switch to holding **Volume Up + Home + Power** until TWRP appears.
2. Flash `T713-fingerprint-v4-uninstall.zip`, then reboot to System.

The most likely cause is that the SELinux rules module wasn't active. Check that it is installed and switched on in Magisk, then try Step 4 again.

### Stuck on the boot animation later, with a PIN set

Try the safety net first. This keeps your PIN working:

1. Boot TWRP the same way: hold **Volume Down + Home + Power** for about 10 seconds until the screen goes black, then immediately switch to **Volume Up + Home + Power**.
2. Go to **Advanced → File Manager** and open `/data/adb/modules/t713_fp_permissive/`.
3. Delete the file named **`disable`**. This switches the permissive module back on.
4. Reboot to System.

If the tablet boots, SELinux is running permissive. Your tablet is less secure until the problem is fixed, so please open an issue.

If that does not help, flashing the uninstall zip will make the tablet boot, but **your PIN will no longer work**, and you will most likely need **TWRP → Wipe → Format Data**, which erases everything.

### "Add fingerprint" won't start, or fingerprints disappear after a reboot

The package links the folder the fingerprint service reads (`/data/vendor/biometrics/fp/User_0`) to the folder where Samsung's library actually saves fingerprints (`/data/biometrics/fp/User_0`). If that link is missing, Android thinks there are no fingerprints and removes them, while Samsung's library still thinks its slots are full.

To reset the fingerprint data and recreate the link, run this from a **root** ADB shell (`adb shell`, then `su`). It's one line:

```
stop vendor.fingerprint-default; rm -rf /data/biometrics/fp /data/biometrics/info; rmdir /data/vendor/biometrics/fp/User_0; rm -f /data/vendor/biometrics/fp/User_0; mkdir -p /data/biometrics/fp/User_0; chown -R system:system /data/biometrics; chmod 0700 /data/biometrics/fp /data/biometrics/fp/User_0; restorecon -R /data/biometrics; ln -s /data/biometrics/fp/User_0 /data/vendor/biometrics/fp/User_0; start vendor.fingerprint-default
```

Then delete any fingerprints still listed in Settings and enroll again.

### Collecting a log for a bug report

From a PC with ADB:

```
adb logcat -b all -c
```

Reproduce the problem, then:

```
adb shell "logcat -b all -d | grep -iE 'bauth|fingerprint|gatekeeper|vfsspi|avc: denied'" > t713-log.txt
```

Attach `t713-log.txt` to your issue.

---

## How it works (technical)

retiredtab's ROM already contains everything at the hardware level: the Validity/Synaptics `vfsspi` kernel driver, the `/dev/vfsspi` and `/dev/qseecom` device nodes, Samsung's `libbauthserver.so`, and the TrustZone fingerprint apps (`fingerpr`, `securefp`). What was missing:

1. **A fingerprint service.** The package adds LineageOS's AIDL Samsung fingerprint service (`android.hardware.biometrics.fingerprint-service.samsung`, from `hardware/samsung` lineage-22.2). It loads Samsung's `libbauthserver.so`. The package also adds the AIDL interface libraries the service needs, its VINTF manifest entry, and the `android.hardware.fingerprint` feature file.

2. **A gatekeeper the TrustZone trusts.** Before enrolling, Android sends Samsung's TrustZone fingerprint app a token proving you just entered your PIN. The ROM's software gatekeeper signs that token with a key the TrustZone doesn't know, so enrollment was rejected (`BAuth_Hat_OP fail`). The package disables the software gatekeeper and runs the standard `android.hardware.gatekeeper@1.0-service`, which loads the tablet's own TrustZone module `gatekeeper.msm8952.so`.
   - That module waits forever for the property `sys.keymaster.loaded=true`, which used to be set by Samsung's TrustZone keymaster. The ROM uses a software keymaster, so the package sets the property itself at `early-boot`. The module then loads the keymaster TrustZone app on its own.

3. **Settings for Samsung's older library.** The service is told the sensor is a home-button sensor, that this library reports enrollment progress as a percentage (`uses_percentage_samples`), and to cancel the session when enrollment completes (`cancel_on_enroll_completion`). Without the percentage setting, enrollment never progresses. `force_calibrate` is also set, matching the tested configuration. The library reports that request as unsupported, which is harmless.

4. **Folders.** Samsung's library ignores the folder the service gives it and always uses `/data/biometrics`. The package creates that folder with the correct SELinux label, and symlinks `/data/vendor/biometrics/fp/User_0` to `/data/biometrics/fp/User_0` so the service can list enrolled fingerprints after a reboot.

5. **SELinux rules** (Magisk module, `sepolicy.rule`, also applied live at `post-fs-data`):
   ```
   allow hal_gatekeeper_default system_prop file { read open getattr map }
   allow hal_fingerprint_default default_prop file { read open getattr map }
   allow hal_fingerprint_default vendor_data_file dir { read open search getattr }
   allow hal_fingerprint_default vendor_data_file lnk_file { read getattr }
   ```

The TWRP installer (`src/flashable/META-INF/com/google/android/update-binary`) is a plain shell script. It checks the device and Android version, verifies file checksums, backs up the software gatekeeper's init file, copies the files with the correct owners, permissions and SELinux labels, and records everything it changed in `/vendor/etc/t713-fingerprint.installed`, so the uninstaller can undo it exactly. Install and uninstall use the same script; the zip's `mode` file selects which.

**No Samsung proprietary files are included.** Every Samsung component used is already part of retiredtab's ROM.

---

## Repository layout

```
downloads/                       Ready-to-flash zips
src/flashable/                   Contents of the TWRP zips (add a file named "mode"
                                 containing "install" or "uninstall" when zipping)
src/magisk-sepolicy/             Contents of the SELinux rules Magisk module
src/magisk-recovery-permissive/  Contents of the safety-net permissive Magisk module
```

---

## Credits

- **retiredtab** for keeping LineageOS alive on the Galaxy Tab S2. Please don't ask them for support for this package.
- **The LineageOS project** for the `hardware/samsung` fingerprint service and the Tab S5e build the binaries came from.
- **topjohnwu** for Magisk.

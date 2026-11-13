# Fingerprint sensor for the Samsung Galaxy Tab S2 SM-T713 on LineageOS 22.2

## What is this, and why would I want it?

retiredtab's LineageOS 22.2 keeps the 2016 **Samsung Galaxy Tab S2 8.0 (SM-T713)** running a modern, secure Android 15. One thing doesn't work on it: the **fingerprint sensor in the home button**.

This package fixes that. Once it's installed, you can:

- add fingerprints in Settings
- unlock the lock screen with your fingerprint
- use fingerprint login inside apps that support it (tested with Aegis Authenticator, which protects its vault key the same way password managers do)

SELinux, one of Android's main security protections, stays fully on ("enforcing").

It has been tested **only** with retiredtab's ROM from this thread: https://xdaforums.com/t/unofficial-rom-alpha-lineageos-22-2-for-sm-t713-sep-9-2026.4761196/

> **This is an unofficial, community-made hack. It is not supported by retiredtab or by LineageOS. Please do not ask retiredtab or the LineageOS devs for help with it.**

---

## Requirements

| What | Version tested | Where to get it |
|---|---|---|
| Tablet | Samsung Galaxy Tab S2 8.0 Wi-Fi, **SM-T713** (`gts28vewifi`). No other model. | — |
| ROM | **retiredtab's LineageOS 22.2** (Android 15), **Sep 9, 2026** release (`lineage-22.2-20260909-UNOFFICIAL-gts28vewifi`), already installed and set up | [retiredtab's XDA thread](https://xdaforums.com/t/unofficial-rom-alpha-lineageos-22-2-for-sm-t713-sep-9-2026.4761196/) |
| Recovery | **TWRP 3.6.2_9-0** (`twrp-3.6.2_9-0-gts28vewifi.img`) | [twrp.me](https://twrp.me/samsung/samsunggalaxytabs280wifi2016.html) / [downloads](https://dl.twrp.me/gts28vewifi/) |
| Root | **Magisk v31.1**, installed and working | [Magisk releases](https://github.com/topjohnwu/Magisk/releases) |
| This package | The four zip files from **v4** | [Releases](https://github.com/tomtombombadil/SM-T713-LineageOSv22_2-Fingerprint-Sensor/releases/latest) (also in the [`downloads`](downloads) folder) |
| Storage | A **microSD card** is recommended, because TWRP can always read it | — |

A PC, USB cable and ADB are **not** needed to install this. They're only useful for some troubleshooting (see the end of this guide).

**The four package files:**

| File | What it does | Installed with |
|---|---|---|
| `T713-fingerprint-v4-install.zip` | The fingerprint package | TWRP |
| `T713-fingerprint-v4-uninstall.zip` | Removes the package and restores the ROM's original files. Keep it. | TWRP |
| `T713-fingerprint-selinux-rules-magisk.zip` | Security rules the package needs. **Required:** without it the tablet won't start. | Magisk → Modules |
| `T713-recovery-permissive-magisk.zip` | A safety net. Installed but switched **off**; only switched on to rescue a tablet that won't start. | Magisk → Modules |

---

## Risks

> [!WARNING]
> **Before you update LineageOS — from retiredtab or from anyone else — always delete all fingerprints and set the screen lock to "None" first.** The same applies before uninstalling this package or flashing a different ROM. If you skip this, you'll most likely be locked out and have to erase the tablet.
>
> **Why:** this package replaces the part of Android that checks your PIN. LineageOS normally uses a *software* PIN checker; this package switches to the tablet's *hardware* (TrustZone) PIN checker, which the fingerprint sensor needs. A PIN created with one can't be read by the other, and updating or uninstalling brings the software one back.

By installing this, you also accept that:

- **You could lose everything on the tablet.** If something goes wrong while a PIN is set, the only way back in may be to erase it (TWRP → Wipe → Format Data).
- **The tablet may get stuck on the boot animation.** The troubleshooting section explains how to recover, using TWRP.
- **It changes how your tablet's security works.** It replaces the PIN checker, adds a fingerprint program, and adds security rules through Magisk. It needs root. It has had far less testing and review than anything official.
- **Some of its programs were built for a different tablet.** The fingerprint and PIN-checking programs come from the official LineageOS 22.2 build for the Galaxy Tab S5e. They are standard LineageOS/Android programs, but they weren't built specifically for this tablet.
- **It has been tested on one tablet only**, with the ROM, TWRP and Magisk versions listed above.
- **There's no warranty.** You use it entirely at your own risk.

---

## Quick install (advanced users)

1. Copy the four zips to the microSD card. Make a TWRP backup of **System** and **Boot**.
2. Set the screen lock to **None** and delete any fingerprints.
3. In **Magisk → Modules → Install from storage**, install `T713-fingerprint-selinux-rules-magisk.zip` (leave it **ON**) and `T713-recovery-permissive-magisk.zip` (switch it **OFF**). Don't reboot to System yet.
4. Boot TWRP (Volume Up + Home + Power), flash `T713-fingerprint-v4-install.zip`, then reboot to System.
5. Set a PIN, then reboot once and check that the PIN works.
6. Enroll fingerprints. If the first attempt after a reboot says "Something went wrong", just retry.

Before any LineageOS update: remove fingerprints and the PIN. Then flash the update, flash Magisk, flash `T713-fingerprint-v4-install.zip`, and reboot. See [Life cycle](#life-cycle-updating-and-uninstalling).

---

## Full installation instructions

Follow these steps in order. If anything here is unfamiliar (checking your versions, installing Magisk, copying files), see [Pre-install help](#pre-install-help) near the end.

### Step 1 — Copy the files to the tablet

Download the four zip files from the [v4 release](https://github.com/tomtombombadil/SM-T713-LineageOSv22_2-Fingerprint-Sensor/releases/latest) and copy them to the tablet's **microSD card**. You can download them directly on the tablet, or copy them from a PC (see [Copying files to the tablet](#copying-files-to-the-tablet)).

Keep a copy on your PC as well.

### Step 2 — Back up

1. Copy any photos, documents and other files you care about off the tablet.
2. Make a TWRP backup:
   1. Turn the tablet off. Then press and hold **Volume Up + Home + Power** until the **TWRP** screen appears, and let go.
   2. Tap **Backup**.
   3. Tap **Select Storage**, choose **Micro SDcard**, and tap **OK**.
   4. Tick **System** and **Boot**.
   5. **Swipe to Backup** and wait for it to finish.
   6. Tap **Reboot System**. If TWRP offers to install the TWRP app, choose **Do Not Install**.

### Step 3 — Remove the screen lock

1. Open **Settings → Security** (on some builds called **Security & privacy**). If you have any fingerprints listed, delete them.
2. Tap **Screen lock**, enter your current PIN/pattern/password, and choose **None**. Confirm when asked.

> Don't skip this. Your current PIN belongs to the software PIN checker and will stop working once the package is installed.

### Step 4 — Install the two Magisk modules

1. Open the **Magisk** app and tap **Modules** at the bottom (the puzzle-piece icon).
2. Tap **Install from storage**, browse to the microSD card (use the **☰** menu at the top left if needed), and tap **`T713-fingerprint-selinux-rules-magisk.zip`**. Wait until the log says it's done, then tap the back arrow.
3. Do the same for **`T713-recovery-permissive-magisk.zip`**.
4. In the Modules list:
   - **T713 fingerprint SELinux rules**: make sure its switch is **ON**.
   - **T713 fingerprint test - permissive SELinux**: switch it **OFF**. Leave it installed; it's your rescue tool if the tablet ever won't start.
5. Don't reboot to System yet. Go straight to Step 5.

> The SELinux rules module must be installed and switched on **before** you flash the package. Without it, the tablet will get stuck on the boot animation.

### Step 5 — Flash the package in TWRP

1. Turn the tablet off. Press and hold **Volume Up + Home + Power** until TWRP appears.
   - If TWRP asks **"Keep System Read only?"**, choose **Swipe to Allow Modifications**.
2. Tap **Install**, then **Select Storage → Micro SDcard → OK**.
3. Tap **`T713-fingerprint-v4-install.zip`**, then **Swipe to confirm Flash**.
4. Read the messages. A successful install ends with **"Done. Reboot to System."** If you see a line starting with **ERROR**, nothing harmful was done; the message says why (usually the wrong tablet, the wrong Android version, or a damaged download).
5. Tap **Reboot System**. The first start may take a little longer than usual.

### Step 6 — Set a new PIN

1. Open **Settings → Security → Screen lock**, choose **PIN** (or Pattern or Password), and enter it twice.
2. Lock the tablet with the **Power** button and unlock it with your PIN, two or three times.
3. Restart the tablet (hold **Power → Restart**) and unlock with your PIN again.

This checks that the new PIN checker works before you rely on it. If setting the PIN fails, **stop** and see [Troubleshooting](#troubleshooting).

### Step 7 — Add your fingerprint

1. Open **Settings → Security → Fingerprint** and enter your PIN.
2. Tap **Add fingerprint** and follow the screens.
3. When asked to touch the sensor, rest your finger flat on the **Home button** (no need to press it), lift it, and repeat. Shift your finger slightly each time. The circle fills up as you go.
4. When it says the fingerprint was added, tap **Done** (or **Add another**).

> If you see **"Can't complete fingerprint setup. Something went wrong"** on the first try, just try again. The first attempt after each restart sometimes fails; the second works.

### Step 8 — Test it

1. Lock the tablet, wake the screen, and rest your finger on the Home button. It should unlock.
2. Restart once more. Unlock with your **PIN** the first time (that's normal, see below), then lock again and check that your fingerprint works.

**You're done.**

---

## Using it

- **After every restart, the first unlock needs your PIN.** This is standard Android behavior on every phone and tablet. After that, fingerprints work.
- **Up to 4 fingerprints**, which is Samsung's limit for this sensor. Add or remove them in **Settings → Security → Fingerprint**.
- **In apps:** look for a setting such as "Use fingerprint", "Biometric unlock" or "Unlock with biometrics", usually under the app's security settings.
- **Main user only.** Extra user profiles on the tablet aren't supported.

---

## Life cycle: updating and uninstalling

> [!WARNING]
> **Every** action in this section starts the same way: **delete all fingerprints and set the screen lock to "None" first.**

| When | What to do |
|---|---|
| A new LineageOS build comes out (from retiredtab or anyone else) | [Updating LineageOS](#updating-lineageos) |
| A new version of this package comes out | [Updating this package](#updating-this-package) |
| LineageOS moves to a newer Android version (for example LineageOS 23) | This package won't install there. Leave the screen lock at None until a compatible version exists. |
| You want to remove fingerprint support | [Uninstalling](#uninstalling) |
| You're switching to a different ROM | [Uninstalling](#uninstalling) first, then install the other ROM |

Keep the four zips, plus `Magisk-v31.1.zip`, on the microSD card so they're always there when you need them.

### Updating LineageOS

1. Delete all fingerprints, and set **Screen lock** to **None**.
2. Boot into TWRP and flash the LineageOS update the way retiredtab's instructions describe. The update overwrites the system and boot partitions, which removes both this package **and** Magisk.
3. Get Magisk back **before** you put this package back. Without Magisk, the SELinux rules aren't loaded and the tablet will get stuck on the boot animation. Choose one of these:
   - **(a)** In the same TWRP session: flash `Magisk-v31.1.zip`, then flash `T713-fingerprint-v4-install.zip`, then **Reboot System**.
   - **(b)** Reboot to System *without* this package, reinstall Magisk the way you normally do, and check in **Magisk → Modules** that both modules are still there with the same on/off settings (they normally survive updates). Then boot TWRP, flash `T713-fingerprint-v4-install.zip`, and reboot.
4. Set your PIN again (Step 6) and add your fingerprints again (Step 7).

The installer only runs on Android 15. If a future LineageOS release moves to a newer Android version, it won't install; leave the screen lock at None.

### Updating this package

1. Read the new version's release notes first. They may have extra steps.
2. Delete all fingerprints, and set **Screen lock** to **None**.
3. If the release includes new Magisk modules, install them over the old ones (Magisk → Modules → Install from storage). Keep SELinux rules **ON** and the safety net **OFF**.
4. Boot TWRP and flash the new install zip. It removes the previous version automatically.
5. Reboot, then set your PIN and add your fingerprints again.

Keep the uninstall zip that matches the version you have installed.

### Uninstalling

1. Delete all fingerprints, and set **Screen lock** to **None**.
2. Boot TWRP and flash **`T713-fingerprint-v4-uninstall.zip`**. It should end with **"Removed. Reboot to System."**
3. **Reboot System.**
4. In **Magisk → Modules**, remove **T713 fingerprint SELinux rules** and **T713 fingerprint test - permissive SELinux** (the trash-can button on each), then reboot.
5. Set your PIN again.

A small folder of fingerprint data (`/data/biometrics`) is left behind. It's harmless.

**Switching to a different ROM?** Uninstall first, while you're still on retiredtab's LineageOS 22.2, then install the other ROM following its own instructions.

---

## Troubleshooting

### Getting into TWRP when the tablet is stuck

1. Hold **Volume Down + Home + Power** for about 10 seconds, until the screen goes black. This forces a restart.
2. As soon as it goes black, switch to holding **Volume Up + Home + Power** until TWRP appears.

### Stuck on the boot animation right after installing

No PIN is set at this point, so this is safe to undo. Get into TWRP (above), flash **`T713-fingerprint-v4-uninstall.zip`**, and reboot.

The most likely cause is that the **SELinux rules** module wasn't installed or was switched off. Check Step 4, then do Step 5 again.

### Stuck on the boot animation later, with a PIN set

Try the safety net first. It keeps your PIN working:

1. Get into TWRP (above).
2. Tap **Advanced → File Manager**, then open `data` → `adb` → `modules` → `t713_fp_permissive`.
3. Tap the file named **`disable`**, tap **Delete**, and swipe to confirm. This switches the safety-net module back on.
4. Go back and tap **Reboot System**.

If the tablet starts, it's running with reduced security (SELinux "permissive"). Please open an issue on this repository, with a log if you can.

If that doesn't help: flashing the uninstall zip will make the tablet start, but **your PIN will no longer work**, and you'll most likely have to erase the tablet with **TWRP → Wipe → Format Data**. This is why the backup in Step 2 matters.

### Setting a PIN fails or hangs

Don't keep trying. With no PIN set, it's safe to undo: flash **`T713-fingerprint-v4-uninstall.zip`** in TWRP and reboot. Please open an issue.

### "Can't complete fingerprint setup. Something went wrong"

Try again. The first attempt after each restart often shows this. If it keeps happening, restart the tablet and try twice more.

### "Add fingerprint" won't start, or fingerprints disappear after a restart

The package links the folder where the fingerprint program looks for saved fingerprints to the folder where Samsung's software actually saves them. If that link goes missing, Android thinks you have no fingerprints and removes them, while Samsung's software thinks all 4 slots are still full.

To reset the fingerprint data, you need ADB with root (see [Setting up ADB](#setting-up-adb-on-a-windows-pc)):

1. On the PC, type `adb shell`, then type `su`, and approve the Magisk prompt on the tablet. The prompt changes to end in `#`.
2. Paste this (it's one line):
   ```
   stop vendor.fingerprint-default; rm -rf /data/biometrics/fp /data/biometrics/info; rmdir /data/vendor/biometrics/fp/User_0; rm -f /data/vendor/biometrics/fp/User_0; mkdir -p /data/biometrics/fp/User_0; chown -R system:system /data/biometrics; chmod 0700 /data/biometrics/fp /data/biometrics/fp/User_0; restorecon -R /data/biometrics; ln -s /data/biometrics/fp/User_0 /data/vendor/biometrics/fp/User_0; start vendor.fingerprint-default
   ```
3. Type `exit` twice.
4. On the tablet, delete any fingerprints still listed, then add them again.

### Checking that SELinux is enforcing

With ADB set up, run:

```
adb shell getenforce
```

It should print `Enforcing`.

### Collecting a log for a bug report

With ADB set up, clear the log:

```
adb logcat -b all -c
```

Make the problem happen on the tablet, then save the log:

```
adb shell "logcat -b all -d | grep -iE 'bauth|fingerprint|gatekeeper|vfsspi|avc: denied'" > t713-log.txt
```

Attach `t713-log.txt` to your issue, and describe exactly what you did and what you saw.

---

## Pre-install help

### Checking your tablet model and LineageOS version

Open **Settings → About tablet**:

- **Model** should be **SM-T713**.
- **Android version** should be **15**.
- **LineageOS version** should start with **22.2** and end with **gts28vewifi**.

### Checking and updating TWRP

Boot into TWRP (turn the tablet off, then hold **Volume Up + Home + Power**). The version is shown in the title bar at the top, for example **"Team Win Recovery Project 3.6.2_9-0"**.

To update to 3.6.2_9-0:

1. Copy `twrp-3.6.2_9-0-gts28vewifi.img` (from https://dl.twrp.me/gts28vewifi/) to the microSD card.
2. In TWRP, tap **Install → Install Image** (bottom right) → **Select Storage → Micro SDcard → OK**.
3. Tap the `.img` file, choose **Recovery**, and **Swipe to confirm Flash**.
4. Tap **Reboot → Recovery**. The title should now show 3.6.2_9-0.

### Checking or installing Magisk v31.1

**To check:** open the **Magisk** app. The top card should show **Installed: 31.1** (or another version number). If it shows **N/A**, or there's no Magisk app, Magisk isn't installed.

**To install:**

1. Download **`Magisk-v31.1.apk`** from https://github.com/topjohnwu/Magisk/releases.
2. Make a copy and rename the copy to **`Magisk-v31.1.zip`**. (On Windows, if you can't see the `.apk` ending, turn on **View → Show → File name extensions** in File Explorer.)
3. Copy **both** the `.zip` and the `.apk` to the microSD card.
4. Boot TWRP, flash **`Magisk-v31.1.zip`** (**Install → Select Storage → Micro SDcard →** tap the file **→ Swipe to confirm Flash**), and **Reboot System**.
5. Open the **Magisk** app and allow any "additional setup" or reboot it asks for. If the app is missing or doesn't work properly, open the **Files** app, go to the SD card, and tap **`Magisk-v31.1.apk`** to install it, allowing installs from Files if asked. It can take a couple of tries before Magisk shows as fully installed.

### Copying files to the tablet

- **On the tablet:** open this repository's [Releases](https://github.com/tomtombombadil/SM-T713-LineageOSv22_2-Fingerprint-Sensor/releases/latest) page in the browser and tap each zip to download it. Files go to the **Download** folder. Move them to the SD card with the **Files** app, or leave them there, since TWRP can usually read internal storage too.
- **From a Windows PC:** connect the tablet with a USB cable, tap the **USB** notification on the tablet, and choose **File transfer**. The tablet appears in **File Explorer** under **This PC**; copy the files onto its **SD card**.

### Checking the downloads (optional)

On Windows, open Command Prompt in the folder with the files and run, for example:

```
certutil -hashfile T713-fingerprint-v4-install.zip SHA256
```

The result should match:

```
3e3fc01efff5fb13fb50769c5ce0b1a828342db300b4d0710b7da41f151842dc  T713-fingerprint-v4-install.zip
57aae565506520e1431f1daf828486b1e7219f8909b414839397d0ba093ff0b8  T713-fingerprint-v4-uninstall.zip
ff02f471188a5cde5d762a957bc656fac27ed5403fec5201c8e1c2750eb4c210  T713-fingerprint-selinux-rules-magisk.zip
d859a840ed836907b51d5dc0cc98a129448cb5f19218340a0b6deabc62071c2b  T713-recovery-permissive-magisk.zip
```

### Setting up ADB on a Windows PC

ADB is only needed for some troubleshooting steps, not to install.

1. Download **SDK Platform-Tools for Windows** from https://developer.android.com/tools/releases/platform-tools and unzip it, for example to `C:\platform-tools`.
2. On the tablet, open **Settings → About tablet** and tap **Build number** seven times.
3. Open **Settings → System → Developer options** and turn on **USB debugging**.
4. Connect the tablet to the PC with a USB cable.
5. On the PC, open **Command Prompt** and run `cd C:\platform-tools`, then `adb devices`.
6. On the tablet, tick **Always allow from this computer** and tap **Allow**.
7. Run `adb devices` again. The tablet should be listed with `device` after it.

---

## How it works (technical)

retiredtab's ROM already contains everything at the hardware level: the Validity/Synaptics `vfsspi` kernel driver, the `/dev/vfsspi` and `/dev/qseecom` device nodes, Samsung's `libbauthserver.so`, and the TrustZone fingerprint apps (`fingerpr`, `securefp`). What was missing:

1. **A fingerprint service.** The package adds LineageOS's AIDL Samsung fingerprint service (`android.hardware.biometrics.fingerprint-service.samsung`, from `hardware/samsung` lineage-22.2), which loads Samsung's `libbauthserver.so`. It also adds the AIDL interface libraries the service needs, its VINTF manifest entry, and the `android.hardware.fingerprint` feature file.

2. **A gatekeeper the TrustZone trusts.** Before enrolling, Android sends Samsung's TrustZone fingerprint app a token proving you just entered your PIN. The ROM's software gatekeeper signs that token with a key the TrustZone doesn't know, so enrollment was rejected (`BAuth_Hat_OP fail`). The package disables the software gatekeeper and runs the standard `android.hardware.gatekeeper@1.0-service`, which loads the tablet's own TrustZone module `gatekeeper.msm8952.so`.
   - That module waits forever for the property `sys.keymaster.loaded=true`, which Samsung's TrustZone keymaster used to set. The ROM uses a software keymaster, so the package sets the property itself at `early-boot`. The module then loads the keymaster TrustZone app on its own.

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

### Repository layout

```
downloads/                       Ready-to-flash zips (same files as the v4 release)
src/flashable/                   Contents of the TWRP zips (add a file named "mode"
                                 containing "install" or "uninstall" when zipping)
src/magisk-sepolicy/             Contents of the SELinux rules Magisk module
src/magisk-recovery-permissive/  Contents of the safety-net permissive Magisk module
release-notes/                   Release notes for each version
```

---

## Contributing, bugs and security

- **Did it work for you, or not?** Please open a [compatibility report](https://github.com/tomtombombadil/SM-T713-LineageOSv22_2-Fingerprint-Sensor/issues/new/choose). It helps everyone, especially for newer ROM builds.
- **Found a bug?** Open a [bug report](https://github.com/tomtombombadil/SM-T713-LineageOSv22_2-Fingerprint-Sensor/issues/new/choose).
- **Found a security problem?** Please report it privately; see the [Security Policy](SECURITY.md).
- **Want to help?** See [CONTRIBUTING.md](CONTRIBUTING.md). Everyone taking part is expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## License

The scripts and configuration in this repository are licensed under the [Apache License 2.0](LICENSE). The LineageOS/AOSP binaries included are also under the Apache License 2.0; see [NOTICE.md](NOTICE.md) for where they came from.

## Credits

- **tomtombombadil** and **Claude** (AI assistant by Anthropic) created this package together: diagnosing the problem, building the installer, testing on real hardware, and writing this guide.
- **retiredtab** for keeping LineageOS alive on the Galaxy Tab S2. Please don't ask them for support for this package.
- **The LineageOS project** for the `hardware/samsung` fingerprint service and the Tab S5e build the binaries came from.
- **topjohnwu** for Magisk.

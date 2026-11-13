# Fingerprint sensor for the Samsung Galaxy Tab S2 SM-T713 on LineageOS 22.2

This package makes the fingerprint sensor in the home button work on the **Samsung Galaxy Tab S2 8.0 (model SM-T713, codename `gts28vewifi`)** running **retiredtab's unofficial LineageOS 22.2 (Android 15)**.
This has been tested ONLY with the ROM available here: https://xdaforums.com/t/unofficial-rom-alpha-lineageos-22-2-for-sm-t713-sep-9-2026.4761196/

Once it's installed you can:
- add fingerprints in Settings
- unlock the lock screen with your fingerprint
- use fingerprint login inside apps that support it (tested with Aegis Authenticator, which protects its vault key the same way password managers do)

SELinux, one of Android's main security protections, stays fully on ("enforcing").

> **This is an unofficial, community-made hack. It is not supported by retiredtab or by LineageOS. Please do not ask retiredtab or the LineageOS devs for help with it.**

---

# ⚠️ READ THIS BEFORE YOU EVER UPDATE LINEAGEOS ⚠️

## BEFORE YOU UPDATE TO ANY NEW LINEAGEOS RELEASE — FROM RETIREDTAB OR FROM ANYONE ELSE — YOU MUST FIRST REMOVE ALL OF YOUR LOCK SCREEN SECURITY:

## 1. DELETE EVERY FINGERPRINT
## 2. SET THE SCREEN LOCK TO "NONE" (NO PIN, NO PATTERN, NO PASSWORD)

## IF YOU SKIP THIS, YOU WILL MOST LIKELY BE LOCKED OUT OF YOUR TABLET AND HAVE TO ERASE IT COMPLETELY, LOSING EVERYTHING ON IT.

**Why:** this package replaces the part of Android that checks your PIN. LineageOS normally uses a *software* PIN checker; this package switches to the tablet's built-in *hardware* (TrustZone) PIN checker, which the fingerprint sensor needs. A PIN created with one can't be read by the other. Updating LineageOS, flashing any other ROM, or uninstalling this package brings the software PIN checker back, and it won't recognize the PIN you set while this package was installed.

**The same rule applies before uninstalling this package, and before flashing any other ROM.**

---

## Risks — please read

By installing this, you accept that:

- **You could lose everything on the tablet.** If something goes wrong while a PIN is set, the only way back in may be to erase the tablet completely (TWRP → Wipe → Format Data).
- **The tablet may get stuck on the boot animation** and not start. This guide explains how to recover, but you'll need to use TWRP.
- **It changes how your tablet's security works.** It replaces the PIN checker, adds a fingerprint program, and adds security rules through Magisk. It needs root access (Magisk). It has had far less testing and review than anything official.
- **Some of its programs were built for a different tablet.** The fingerprint and PIN-checking programs come from the official LineageOS 22.2 build for the Galaxy Tab S5e. They are standard LineageOS/Android programs, but they weren't built specifically for this tablet.
- **It has been tested on one tablet only**, with retiredtab's build `lineage-22.2-20260909-UNOFFICIAL-gts28vewifi`. Other builds might behave differently.
- **There's no warranty.** You use it entirely at your own risk.

If you aren't comfortable following detailed instructions exactly, using TWRP, or possibly having to erase your tablet, **please don't install this**.

---

## What you need

| Item | Version this was tested with | Notes |
|---|---|---|
| Tablet | Samsung Galaxy Tab S2 8.0 Wi-Fi, **SM-T713** | No other model. The installer refuses to run on anything else. |
| ROM | **retiredtab's LineageOS 22.2** (Android 15), build `lineage-22.2-20260909-UNOFFICIAL-gts28vewifi` | Must already be installed and set up. The installer refuses to run on other Android versions. |
| Recovery | **TWRP 3.6.2_9-0** for `gts28vewifi` (file `twrp-3.6.2_9-0-gts28vewifi.img`) | You almost certainly already have TWRP, because it's needed to install LineageOS. Section A3 shows how to check the version. |
| Root | **Magisk v31.1** | Must be installed and working. Section A6 shows how to check, or how to install it. |
| Storage | A microSD card is recommended | TWRP can always read the microSD card. |
| Optional | A Windows PC with a USB cable | Handy for copying files and for the optional checks. Not required. |

Download links:

- **TWRP for SM-T713:** https://twrp.me/samsung/samsunggalaxytabs280wifi2016.html (downloads: https://dl.twrp.me/gts28vewifi/)
- **Magisk:** https://github.com/topjohnwu/Magisk/releases (tested with v31.1)
- **retiredtab's LineageOS:** see retiredtab's thread for the SM-T713 on XDA Forums
- **This package:** the [`downloads`](downloads) folder of this repository

---

## The files in this package

All four files are in the [`downloads`](downloads) folder. You need all four.

| File | What it does | How it gets installed |
|---|---|---|
| `T713-fingerprint-v4-install.zip` | The fingerprint package itself | Flashed in TWRP |
| `T713-fingerprint-v4-uninstall.zip` | Removes the package and puts the ROM's original files back | Flashed in TWRP (only if you uninstall) |
| `T713-fingerprint-selinux-rules-magisk.zip` | Security rules the package needs. **Required:** without it the tablet won't start. | Installed as a module in the Magisk app |
| `T713-recovery-permissive-magisk.zip` | A safety net, installed but switched **off**. It's only switched on to rescue a tablet that won't start. | Installed as a module in the Magisk app |

SHA-256 checksums (optional, for checking the downloads aren't damaged):

```
3e3fc01efff5fb13fb50769c5ce0b1a828342db300b4d0710b7da41f151842dc  T713-fingerprint-v4-install.zip
57aae565506520e1431f1daf828486b1e7219f8909b414839397d0ba093ff0b8  T713-fingerprint-v4-uninstall.zip
ff02f471188a5cde5d762a957bc656fac27ed5403fec5201c8e1c2750eb4c210  T713-fingerprint-selinux-rules-magisk.zip
d859a840ed836907b51d5dc0cc98a129448cb5f19218340a0b6deabc62071c2b  T713-recovery-permissive-magisk.zip
```

To check one on Windows, open Command Prompt in the folder containing the file and run, for example:

```
certutil -hashfile T713-fingerprint-v4-install.zip SHA256
```

The long string it prints should match the one above.

---

# Part A — Basic skills

The installation steps in Part B refer back to these sections. Read them first if any of this is new to you.

## A1. Check your tablet model and LineageOS version

1. Open **Settings** → **About tablet**.
2. **Model** should say **SM-T713**.
3. **Android version** should say **15**.
4. Look for **LineageOS version**. It should start with **22.2** and end with **gts28vewifi**. You may need to tap **Android version** or scroll down to see it.

If any of these don't match, **stop**. This package isn't for your tablet.

## A2. Boot into TWRP (recovery mode)

"Recovery" is a separate mini-system on the tablet that's used to install and repair things. On this tablet it's TWRP. There are two ways to get into it.

**Method 1 — using the buttons (always works):**

1. Turn the tablet off completely. Hold the **Power** button, tap **Power off**, and wait until the screen is fully black.
2. Press and hold **all three** of these together: **Volume Up**, **Home** (the physical button below the screen), and **Power**.
3. Keep holding all three. The Samsung logo appears, and a few seconds later the **TWRP** screen appears. Then let go. This usually takes 10–15 seconds.
4. If the tablet starts normally instead, turn it off and try again, holding the buttons a little longer.

**If the tablet is stuck** (for example, frozen on the boot animation) and you can't turn it off normally:

1. Hold **Volume Down + Home + Power** for about 10 seconds, until the screen goes black. This forces a restart.
2. As soon as the screen goes black, immediately switch to holding **Volume Up + Home + Power**, and keep holding until TWRP appears.

**Method 2 — from a PC with ADB** (only if you've set up ADB, see A9):

```
adb reboot recovery
```

**The first time TWRP opens after some changes,** it may ask **"Keep System Read only?"**. Choose **Swipe to Allow Modifications**. This package needs to write to the system partition.

**When you leave TWRP:** if it asks to install the **TWRP app**, choose **Do Not Install**.

## A3. Check your TWRP version (and update it if needed)

1. Boot into TWRP (A2).
2. The version is shown in the title bar at the top of the TWRP main screen, for example **"Team Win Recovery Project 3.6.2_9-0"**.
3. If it says **3.6.2_9-0**, you're set. This package was tested with that version.

**To update TWRP to 3.6.2_9-0:**

1. Download `twrp-3.6.2_9-0-gts28vewifi.img` from https://dl.twrp.me/gts28vewifi/ and copy it to the microSD card (A4).
2. Boot into TWRP (A2).
3. Tap **Install**, then tap **Install Image** (bottom right).
4. Tap **Select Storage**, choose **Micro SDcard**, and tap **OK**.
5. Tap the file `twrp-3.6.2_9-0-gts28vewifi.img`.
6. When it asks which partition, choose **Recovery**, then **Swipe to confirm Flash**.
7. Go back to the main screen and tap **Reboot** → **Recovery**. TWRP restarts, and the title should now show 3.6.2_9-0.

## A4. Copy files to the tablet

**Option 1 — download directly on the tablet:**

1. On the tablet, open the web browser and go to this repository's page.
2. Open the **downloads** folder and tap a file name.
3. Tap the **Download** button (the down-arrow icon, or "Download raw file").
4. The file is saved in the tablet's **Download** folder (internal storage).
5. Repeat for each file.

**Option 2 — copy from a Windows PC over USB:**

1. Download the files on your PC.
2. Connect the tablet to the PC with a USB cable.
3. On the tablet, pull down the notification shade and tap the **USB** notification (for example "Charging this device via USB"). Choose **File transfer**.
4. On the PC, open **File Explorer**. The tablet appears under **This PC** (for example as **SM-T713**).
5. Open it. You'll see **Internal shared storage** and, if a card is inserted, the **SD card**.
6. Copy the files into the **SD card** (recommended) or into **Internal shared storage → Download**.

**Why the microSD card is recommended:** TWRP can always read the microSD card. It can usually read internal storage too, but not in every situation.

## A5. Flash ("install") a zip file in TWRP

1. Boot into TWRP (A2).
2. Tap **Install**.
3. Tap **Select Storage** at the bottom, choose where your file is (**Micro SDcard** or **Internal Storage**), and tap **OK**.
4. Browse to the file. On internal storage, files are usually in the **Download** folder.
5. Tap the zip file you want to install.
6. On the next screen, **Swipe to confirm Flash**.
7. Watch the text messages. They tell you whether it worked. Read them before continuing.
8. When it finishes, tap **Reboot System**, unless the instructions say to do something else first.

## A6. Check that Magisk is installed (and install it if it isn't)

**To check:**

1. Open the **Magisk** app on the tablet.
2. At the top, the **Magisk** card should show **Installed** with a version number, for example **31.1**.
3. If it shows **Installed: N/A**, or there's no Magisk app, Magisk isn't installed. Follow the steps below.

**To install Magisk v31.1** (only if it isn't installed already):

1. Download **`Magisk-v31.1.apk`** from https://github.com/topjohnwu/Magisk/releases (look under **Assets** for v31.1).
2. Make a copy of the file and rename the copy from **`Magisk-v31.1.apk`** to **`Magisk-v31.1.zip`**.
   - On Windows, if you can't see the `.apk` ending: in File Explorer, click **View** → **Show** → **File name extensions** (on Windows 10: **View** → tick **File name extensions**).
3. Copy **both** files, the `.zip` and the `.apk`, to the microSD card (A4).
4. Boot into TWRP (A2) and flash **`Magisk-v31.1.zip`** (A5). Then **Reboot System**.
5. When the tablet has started, look for the **Magisk** app.
   - **If it's there:** open it. If it asks to do "additional setup" or to reboot, allow it.
   - **If it's missing or doesn't open properly:** open the **Files** app, go to the SD card, and tap **`Magisk-v31.1.apk`** to install it. Android may ask you to allow installing apps from Files; allow it. Open Magisk afterward, and allow any additional setup or reboot it asks for. It can take a couple of tries before Magisk shows as fully installed.
6. Check again (top of this section). The Magisk card should show **Installed: 31.1**.

## A7. Install a Magisk module, and switch one on or off

A "module" is an add-on that Magisk loads every time the tablet starts.

**To install a module:**

1. Open the **Magisk** app.
2. Tap **Modules** in the bar at the bottom of the screen (the puzzle-piece icon).
3. Tap **Install from storage** at the top.
4. A file picker opens. Browse to where you saved the module zip: tap the **☰** menu (top left) to choose the SD card or **Downloads**.
5. Tap the module zip file.
6. Magisk shows an installation log. Wait until it says it's done.
7. Tap the **back arrow** (top left) to return to the Modules list. **Don't tap "Reboot" yet** unless the instructions say so.

**To switch a module on or off:**

1. In **Magisk → Modules**, each module has a **switch** on the right.
2. Tap it to turn the module on or off. The change takes effect the next time the tablet starts.
3. Don't tap the **Remove** (trash can) button unless the instructions say to.

## A8. Find the lock-screen and fingerprint settings

On LineageOS 22.2 these settings are under **Settings → Security** (on some builds called **Security & privacy**, sometimes inside a section called **Device unlock**):

- **Screen lock**: choose **None**, **Pattern**, **PIN** or **Password**.
- **Fingerprint** (sometimes **Fingerprint Unlock**): add or delete fingerprints. This only appears once this package is installed and a screen lock is set.

**To delete a fingerprint:** open the Fingerprint screen, tap the fingerprint's name, and tap **Delete** (or the trash can icon).

## A9. (Optional) Set up ADB on a Windows PC

ADB lets a PC send commands to the tablet over USB. It isn't required for installation, only for the optional checks and for collecting logs if something goes wrong.

1. Download **SDK Platform-Tools for Windows** from https://developer.android.com/tools/releases/platform-tools and unzip it, for example to `C:\platform-tools`.
2. On the tablet, go to **Settings → About tablet** and tap **Build number** seven times. You'll see "You are now a developer".
3. Go to **Settings → System → Developer options** and turn on **USB debugging**.
4. Connect the tablet to the PC with USB.
5. On the PC, open **Command Prompt**, then go to the folder:
   ```
   cd C:\platform-tools
   ```
6. Run:
   ```
   adb devices
   ```
7. On the tablet, a box asks **"Allow USB debugging?"**. Tick **Always allow from this computer** and tap **Allow**.
8. Run `adb devices` again. Your tablet should be listed with the word `device` after it.

---

# Part B — Installation, step by step

Do these steps **in order** and don't skip any.

### Step 1 — Check you have the right tablet and software

- Model **SM-T713**, Android **15**, LineageOS **22.2** (A1).
- TWRP **3.6.2_9-0** (A3).
- Magisk installed, version **31.1** (A6).

### Step 2 — Download the package files and copy them to the tablet

Copy all four files from the [`downloads`](downloads) folder to the tablet's **microSD card** (A4):

- `T713-fingerprint-v4-install.zip`
- `T713-fingerprint-v4-uninstall.zip`
- `T713-fingerprint-selinux-rules-magisk.zip`
- `T713-recovery-permissive-magisk.zip`

Keep a copy on your PC too.

### Step 3 — Back up

1. Copy anything on the tablet that you care about (photos, documents and so on) to your PC.
2. Make a TWRP backup:
   1. Boot into TWRP (A2).
   2. Tap **Backup**.
   3. Tap **Select Storage**, choose **Micro SDcard**, and tap **OK**.
   4. Tick **System** and **Boot**. (System Image is fine too if it's offered.)
   5. **Swipe to Backup** and wait until it finishes.
   6. Tap **Reboot System**.

If something goes badly wrong later, you can put the system back with TWRP → **Restore**.

### Step 4 — Remove the screen lock

1. Go to **Settings → Security → Screen lock** (A8).
2. Enter your current PIN/pattern/password when asked.
3. Choose **None**. If asked to confirm removing device protection, confirm.
4. If you already have any fingerprints listed, delete them.

> **Don't skip this.** Your current PIN belongs to the software PIN checker and will stop working once the package is installed.

### Step 5 — Install the two Magisk modules

1. Install **`T713-fingerprint-selinux-rules-magisk.zip`** as a Magisk module (A7).
2. Install **`T713-recovery-permissive-magisk.zip`** as a Magisk module (A7).
3. In **Magisk → Modules** you should now see two entries:
   - **T713 fingerprint SELinux rules**: make sure its switch is **ON**.
   - **T713 fingerprint test - permissive SELinux**: **switch it OFF**. Leave it installed, because it's your rescue tool (see Troubleshooting).
4. Don't reboot to System yet; go straight to Step 6.

> The SELinux rules module **must** be installed and switched on **before** you flash the package. Without it, the tablet will get stuck on the boot animation.

### Step 6 — Flash the fingerprint package in TWRP

1. Boot into TWRP (A2). You can go straight from Magisk: turn the tablet off, then use the buttons.
2. Flash **`T713-fingerprint-v4-install.zip`** (A5).
3. Read the messages. A successful install looks like this:
   ```
   T713 fingerprint package v4
   Vendor folder: ...
     disabled software gatekeeper (...)
     installed bin/hw/android.hardware.biometrics.fingerprint-service.samsung
     ...
   Done. Reboot to System.
   ```
   If you see a line starting with **ERROR**, nothing harmful was done. Read the message: it usually means the wrong tablet, the wrong Android version, or a damaged download.
4. Tap **Reboot System**.

The first start may take a little longer than usual.

### Step 7 — Set a new PIN

1. Go to **Settings → Security → Screen lock** and choose **PIN** (or Pattern or Password).
2. Enter it twice to confirm.
3. Test it: press the **Power** button to lock the tablet, press it again, and unlock with your PIN. Do this two or three times.
4. **Restart the tablet** (hold **Power** → **Restart**) and unlock with your PIN again.

This checks that the new hardware PIN checker is working before you rely on it. If setting the PIN fails or the tablet won't accept it, **stop** and see Troubleshooting.

### Step 8 — Add your fingerprint

1. Go to **Settings → Security → Fingerprint** (A8). Enter your PIN when asked.
2. Tap **Add fingerprint** and follow the screens.
3. When it asks you to **touch the sensor**, place your finger flat on the **Home button** (no need to press it down), lift it, and repeat. Move your finger slightly each time so different parts get recorded. The circle on screen fills up as you go.
4. When it says the fingerprint was added, tap **Done** (or **Add another**).

> **If you see "Can't complete fingerprint setup. Something went wrong" on the very first try, just try again.** The first attempt after each restart sometimes fails; the second works.

### Step 9 — Test it

1. Press **Power** to lock the tablet.
2. Press **Power** again (or press **Home**) to wake the screen, then rest your finger on the Home button. The tablet should unlock.
3. Restart the tablet once more. Unlock with your **PIN** the first time (that's normal, see Part C), then lock again and check that your fingerprint works.

### Step 10 (optional) — Check that SELinux is enforcing

If you've set up ADB (A9), run:

```
adb shell getenforce
```

It should print **`Enforcing`**. That means the security protections are fully on, as intended.

**You're done!**

---

# Part C — Using it

- **Unlocking:** wake the screen and rest a registered finger on the Home button.
- **After every restart, the first unlock needs your PIN.** This is standard Android behavior on every phone and tablet, and it isn't a fault. After that, fingerprints work.
- **Adding more fingerprints:** Settings → Security → Fingerprint → **Add fingerprint**. You can register **up to 4** fingerprints, which is Samsung's limit for this sensor.
- **Removing a fingerprint:** Settings → Security → Fingerprint → tap it → **Delete**.
- **In apps:** apps that support fingerprint login usually have a setting such as "Use fingerprint", "Biometric unlock" or "Unlock with biometrics", often under the app's **Security** settings. Turn it on there and follow the app's prompts. Tested working with **Aegis Authenticator** (from F-Droid).
- **Main user only:** fingerprints work for the tablet's main (owner) user. Extra user profiles aren't supported.

---

# Life cycle — keeping it working over time

Once it's installed, this is what you'll do over the life of the tablet:

| When | What to do | Section |
|---|---|---|
| retiredtab (or anyone) releases a **new LineageOS build** | Remove PIN and fingerprints → update LineageOS → reinstall Magisk → reinstall this package → set PIN and fingerprints again | [Updating LineageOS](#updating-lineageos) |
| A **new version of this package** is released | Remove PIN and fingerprints → flash the new install zip → set PIN and fingerprints again | [Updating this package](#updating-this-package) |
| LineageOS moves to a **newer Android version** (for example LineageOS 23) | Don't install this package. Leave the screen lock at None until a compatible version of this package exists. | [Updating LineageOS](#updating-lineageos) |
| You want to **remove** the fingerprint support | Remove PIN and fingerprints → flash the uninstall zip → remove the Magisk modules | [Uninstalling](#uninstalling) |
| You **switch to a different ROM** | Remove PIN and fingerprints → uninstall this package first → then install the other ROM | [Uninstalling](#uninstalling) |

## THE RULE FOR EVERY ONE OF THESE: DELETE ALL FINGERPRINTS AND SET THE SCREEN LOCK TO "NONE" FIRST.

---

# Updating LineageOS

# ⚠️ FIRST DELETE ALL FINGERPRINTS AND SET THE SCREEN LOCK TO "NONE" ⚠️

## THIS APPLIES TO EVERY LINEAGEOS UPDATE — RETIREDTAB'S MONTHLY BUILDS OR ANY OTHER ROM. IF YOU FORGET, YOU WILL MOST LIKELY BE LOCKED OUT AND HAVE TO ERASE THE TABLET.

1. **Settings → Security → Fingerprint:** delete **every** fingerprint (A8).
2. **Settings → Security → Screen lock:** choose **None** (A8).
3. Boot into TWRP (A2) and flash the LineageOS update the way retiredtab's instructions describe. The update overwrites the system and boot partitions, which removes both this package **and** Magisk.
4. Get Magisk back **before** you put this package back. Without Magisk, the SELinux rules module isn't loaded and the tablet will get stuck on the boot animation. Choose **one** of these:
   - **(a)** In the same TWRP session, flash `Magisk-v31.1.zip` (A6), then flash `T713-fingerprint-v4-install.zip` (A5), then **Reboot System**.
   - **(b)** **Reboot System** without flashing this package. Reinstall Magisk (A6), open **Magisk → Modules** and check that both modules are still listed with the same on/off settings (they normally survive updates). Then boot into TWRP (A2) and flash `T713-fingerprint-v4-install.zip` (A5), and reboot.
5. Set your PIN again (Part B, Step 7) and add your fingerprints again (Step 8).

The installer only runs on Android 15. If a future LineageOS release moves to a newer Android version, this package won't install. In that case, leave the screen lock set to None until you know what you're going to do.

**Keep the four zip files** (and `Magisk-v31.1.zip`) on the microSD card, so they're always there when you update.

---

# Updating this package

When a newer version of this package is released:

1. Read the new version's release notes first. They may have extra steps.
2. **Delete all fingerprints** and set the **screen lock to None** (A8).
3. If the release includes new Magisk modules, install them over the old ones (A7). Magisk replaces the old version, and you keep the same on/off settings: SELinux rules **ON**, safety net **OFF**.
4. Boot into TWRP (A2) and flash the new version's install zip (A5). It removes the previous version automatically before installing.
5. **Reboot System**, then set your PIN (Part B, Step 7) and add your fingerprints again (Step 8).

**Keep the uninstall zip that matches the version you have installed.** If you ever need to uninstall, use the uninstall zip from the same release.

---

# Uninstalling

1. **Delete all fingerprints** and set the **screen lock to None** (A8), for the same reason as above.
2. Boot into TWRP (A2) and flash **`T713-fingerprint-v4-uninstall.zip`** (A5). It removes the package's files and puts back the ROM's original software PIN checker. It should end with **"Removed. Reboot to System."**
3. **Reboot System.**
4. Open **Magisk → Modules** and remove **T713 fingerprint SELinux rules** and **T713 fingerprint test - permissive SELinux** (tap the trash-can button on each). Then reboot.
5. Set your PIN again.

A small folder of fingerprint data (`/data/biometrics`) is left behind. It's harmless.

**Switching to a different ROM?** Do steps 1–5 above first, while you're still on retiredtab's LineageOS 22.2, then install the other ROM following its own instructions.

---

# Troubleshooting

### The tablet is stuck on the boot animation right after installing (Step 6)

No PIN is set at this point, so this is safe to undo:

1. Force the tablet into TWRP: hold **Volume Down + Home + Power** for about 10 seconds until the screen goes black, then immediately hold **Volume Up + Home + Power** until TWRP appears (A2).
2. Flash **`T713-fingerprint-v4-uninstall.zip`** (A5), then **Reboot System**.

The tablet should start normally again. The most likely cause is that the **SELinux rules** module wasn't installed or was switched off. Check Step 5, then try Step 6 again.

### The tablet gets stuck on the boot animation later, while a PIN is set

Try the safety net first. It keeps your PIN working:

1. Force the tablet into TWRP as above.
2. Tap **Advanced → File Manager**.
3. Browse to **`/data/adb/modules/t713_fp_permissive/`**: tap `data`, then `adb`, then `modules`, then `t713_fp_permissive`.
4. Tap the file named **`disable`**, then tap **Delete** and swipe to confirm. This switches the safety-net module back on.
5. Go back and tap **Reboot System**.

If the tablet starts, it's running with reduced security (SELinux "permissive"). Please open an issue on this repository with a log (see below) so the problem can be fixed.

**If that doesn't help:** flashing `T713-fingerprint-v4-uninstall.zip` will make the tablet start, but **your PIN will no longer work**, and you'll most likely have to erase the tablet with **TWRP → Wipe → Format Data** (type `yes`). This deletes everything on internal storage. This is why the backup in Step 3 matters.

### Setting a PIN fails or hangs (Step 7)

Don't keep trying. With no PIN set, it's safe to undo: flash **`T713-fingerprint-v4-uninstall.zip`** in TWRP and reboot. Then please open an issue with a log.

### "Can't complete fingerprint setup. Something went wrong"

Try again. The first attempt after each restart often shows this; the second attempt normally works. If it keeps happening, restart the tablet and try twice more.

### "Add fingerprint" won't start, or fingerprints disappear after a restart

The package links the folder where the fingerprint program looks for saved fingerprints to the folder where Samsung's software actually saves them. If that link goes missing, Android thinks you have no fingerprints and removes them, while Samsung's software thinks all 4 slots are still full.

To reset the fingerprint data and recreate the link, you need ADB (A9) with root:

1. On the PC, type:
   ```
   adb shell
   ```
2. Then type:
   ```
   su
   ```
   Approve the Magisk prompt on the tablet. The prompt changes to end in `#`.
3. Paste this (it's one line):
   ```
   stop vendor.fingerprint-default; rm -rf /data/biometrics/fp /data/biometrics/info; rmdir /data/vendor/biometrics/fp/User_0; rm -f /data/vendor/biometrics/fp/User_0; mkdir -p /data/biometrics/fp/User_0; chown -R system:system /data/biometrics; chmod 0700 /data/biometrics/fp /data/biometrics/fp/User_0; restorecon -R /data/biometrics; ln -s /data/biometrics/fp/User_0 /data/vendor/biometrics/fp/User_0; start vendor.fingerprint-default
   ```
4. Type `exit` twice.
5. On the tablet, delete any fingerprints still listed, then add them again.

### Collecting a log for a bug report

With ADB set up (A9), clear the log:

```
adb logcat -b all -c
```

Make the problem happen on the tablet, then save the log:

```
adb shell "logcat -b all -d | grep -iE 'bauth|fingerprint|gatekeeper|vfsspi|avc: denied'" > t713-log.txt
```

Attach `t713-log.txt` to your issue, and describe exactly what you did and what you saw.

---

# How it works (technical)

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

---

## Repository layout

```
downloads/                       Ready-to-flash zips
src/flashable/                   Contents of the TWRP zips (add a file named "mode"
                                 containing "install" or "uninstall" when zipping)
src/magisk-sepolicy/             Contents of the SELinux rules Magisk module
src/magisk-recovery-permissive/  Contents of the safety-net permissive Magisk module
```

## License

The scripts and configuration in this repository are licensed under the [Apache License 2.0](LICENSE). The LineageOS/AOSP binaries included are also under the Apache License 2.0; see [NOTICE.md](NOTICE.md) for where they came from.

## Credits

- **tomtombombadil** and **Claude** (AI assistant by Anthropic) created this package together: diagnosing the problem, building the installer, testing on real hardware, and writing this guide.
- **retiredtab** for keeping LineageOS alive on the Galaxy Tab S2. Please don't ask them for support for this package.
- **The LineageOS project** for the `hardware/samsung` fingerprint service and the Tab S5e build the binaries came from.
- **topjohnwu** for Magisk.

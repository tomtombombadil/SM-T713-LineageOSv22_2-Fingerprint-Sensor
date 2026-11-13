# Contributing

Thanks for wanting to help. This is a small hobby project for one old tablet, so the most useful contributions are simple ones.

By taking part, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

> **Please don't ask retiredtab or the LineageOS developers for help with this package.** It's unofficial, and problems with it belong here.

## Ways to help

### 1. Report whether it works on your tablet

This is the most valuable thing you can do. The package has only been tested on one tablet, with one ROM build. If you've tried it, especially on a **different retiredtab build**, open an issue using the **Compatibility report** template and say whether it worked.

### 2. Report a bug

Open an issue using the **Bug report** template. The template asks for:

- your ROM build, TWRP version, Magisk version and package version
- exactly what you did and what happened
- a log, if you can get one (see "Collecting a log for a bug report" in the [README](README.md#collecting-a-log-for-a-bug-report))

Please search existing issues first, in case someone has already reported it.

### 3. Report a security problem

**Don't open a public issue.** Follow the [Security Policy](SECURITY.md).

### 4. Improve the documentation

If something in the README confused you, open an issue or a pull request suggesting better wording. Instructions written for beginners only get better when beginners say where they got stuck.

### 5. Change the package itself

Pull requests are welcome, but please open an issue first to discuss the change. A broken installer can lock someone out of their tablet, so changes need care.

## Working on the package

### Where things are

```
src/flashable/                   Contents of the TWRP zips
  META-INF/com/google/android/
    update-binary                The installer/uninstaller script
  files/                         Files copied into /vendor
  filelist.txt                   List of files to install
  SHA256SUMS                     Checksums of the files in files/ (the installer checks them)
src/magisk-sepolicy/             The SELinux rules Magisk module
src/magisk-recovery-permissive/  The safety-net Magisk module
downloads/                       The built zips
```

### Rules for changes

- **Never add Samsung proprietary files.** The package only uses Samsung files that are already in retiredtab's ROM.
- **Keep Unix (LF) line endings** in scripts, `.rc`, `.rule` and `.prop` files. The repository's `.gitattributes` enforces this; if you edit on Windows, make sure your editor doesn't change them.
- **Keep the uninstaller able to undo everything.** Anything the installer changes must be recorded in the install marker so the uninstall zip can reverse it.
- **Any change that affects the PIN checker (gatekeeper)** must say so clearly in the release notes, including whether users need to remove their PIN before updating.
- **Test on a real SM-T713** before submitting, and describe what you tested in the pull request.

### Building the zips

The TWRP install zip and uninstall zip are built from the same folder. The only difference is a one-line file named `mode` at the top level of the zip, containing `install` or `uninstall`.

1. If you changed anything in `src/flashable/files/`, update `filelist.txt` and `SHA256SUMS` to match.
2. Create the install zip from inside `src/flashable/`. It must contain `META-INF/`, `files/`, `filelist.txt`, `SHA256SUMS` and `mode` (containing `install`) at the top level, not inside a subfolder.
3. Create the uninstall zip the same way, with `mode` containing `uninstall`. It doesn't need the `files/` folder.
4. Magisk module zips are made from inside their folder, with `module.prop` at the top level.
5. Update the checksums in the README and the release notes.

On Windows, 7-Zip works for building the zips. Select the items listed above, not the folder that contains them.

## Pull requests

Fill in the pull request template. It's a short checklist. Keep each pull request to one change, so it's easy to review and test.

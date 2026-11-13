# Security Policy

This package changes security-sensitive parts of the tablet: it replaces the component that checks your PIN (the gatekeeper), adds a fingerprint service, and adds SELinux rules through Magisk. Security problems in it are taken seriously.

## Supported versions

| Version | Supported |
|---|---|
| v4 | ✅ |
| v1–v3 (test builds, never published) | ❌ |

Only the latest release gets fixes. It is supported only on the configuration it was tested with: SM-T713, retiredtab's LineageOS 22.2 Sep 9, 2026 release, TWRP 3.6.2_9-0 and Magisk v31.1.

## What counts as a security issue

Please report privately if you find, for example:

- a way for an app or person to get past the lock screen, PIN or fingerprint check because of this package
- the fingerprint service accepting fingerprints it shouldn't, or unlocking without a valid match
- the SELinux rules giving more access than the package needs
- the installer or Magisk modules weakening the device's security in a way that isn't documented
- tampered or mismatched files in a release (checksums that don't match the README)

These are **not** security issues for this project. Please open a normal issue, or report them where they belong:

- the tablet getting stuck on boot, or being locked out after updating LineageOS without removing the PIN first (see the README's warnings and troubleshooting)
- the safety-net module setting SELinux to permissive when you switch it on (that's what it's for, and it's documented)
- problems in LineageOS itself, Magisk, TWRP, or Samsung's own software; report those to their own projects

## How to report a vulnerability

**Please don't open a public issue for security problems.**

Report it privately through GitHub:

1. Go to this repository's **Security** tab.
2. Click **Report a vulnerability**.
3. Describe the problem, how to reproduce it, and what an attacker could do with it. Include your ROM build, package version, and logs if you have them.

If you don't see **Report a vulnerability**, use the contact method on the maintainer's GitHub profile ([tomtombombadil](https://github.com/tomtombombadil)). If no contact method is listed there, open an issue that only says you have a security report and asks the maintainer to contact you. Don't include any details in that issue.

## What to expect

This is a one-person hobby project, so there's no guaranteed response time. You can expect:

- an acknowledgement, usually within a week or two
- an honest assessment of whether the issue is real and what it affects
- a fix or a documented workaround if one is possible, and credit in the release notes if you'd like it

Please give the maintainer a reasonable chance to fix the issue before you share it publicly.

## Known limitations (not vulnerabilities)

These are documented trade-offs, not hidden flaws:

- The package needs **root** (Magisk), which by itself lowers the device's security compared with an unrooted device.
- The ROM's keymaster is still the **software** keymaster; only the gatekeeper was switched to TrustZone.
- The fingerprint and gatekeeper programs come from the official LineageOS 22.2 build for a different device (the Galaxy Tab S5e). See [NOTICE.md](NOTICE.md).

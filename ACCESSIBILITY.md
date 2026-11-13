# Accessibility

This project should be usable by as many people as possible, including people who use screen readers, have limited dexterity or vision, or are new to modding Android devices.

## What this project covers

The project has two parts:

- **The documentation** (README and the other guides in this repository). This is where most accessibility work happens.
- **The package itself**, which installs fingerprint support on the tablet. It adds no screens or menus of its own. Fingerprint setup and unlocking use Android's standard Settings screens and lock screen.

## Accessibility priorities

- **Plain-language, step-by-step instructions** that assume no prior experience, with every button, menu and setting named in the order you'll meet it.
- **Text, not pictures.** All instructions are written out, so they work with screen readers, translation tools and large text. If screenshots are ever added, each will have a text description, and no step will depend only on an image.
- **Clear structure.** The guides use headings in order, numbered steps and lists, so screen-reader users can jump between sections.
- **No meaning carried by color alone.** Warnings are labeled in words ("Warning", "Important"), not just shown in color.
- **Commands are in their own code blocks**, one per block where possible, so they can be copied without picking up extra text.

## Supported platforms

- **Documentation:** viewed on github.com in any modern web browser, including with screen readers such as NVDA, JAWS, VoiceOver and TalkBack.
- **Package:** the Samsung Galaxy Tab S2 SM-T713 running retiredtab's LineageOS 22.2. Android's built-in accessibility features (TalkBack, magnification, font size, color correction) are part of LineageOS and are not changed by this package.

## Known barriers

These are honest limitations. Most come from the tools this project depends on, not from the package itself.

- **TWRP has no screen reader support.** Installing, updating and uninstalling all require using TWRP's touch interface, which TalkBack can't read. A sighted helper may be needed for those steps.
- **Getting into TWRP normally needs a three-button combination** (Volume Up + Home + Power, held together). This can be hard for people with limited hand strength or dexterity. There are two ways to avoid it while the tablet is working normally:
  - **Power menu (no PC needed):** LineageOS can add a **Recovery** choice to the power menu. Turn it on in **Settings → System → Buttons → Advanced restart** (also called **Advanced reboot**; if you don't see it, turn on Developer options first by tapping **Build number** seven times in **Settings → About tablet**). Then hold **Power**, tap **Restart**, and tap **Recovery**. The power menu works with TalkBack.
  - **From a PC:** with ADB set up, `adb reboot recovery` restarts straight into TWRP.

  Forcing a restart when the tablet is frozen still needs two buttons held together (**Volume Down + Power** for about 8–10 seconds). The README's [Hints and tips](README.md#hints-and-tips) section lists every button combination.
- **Fingerprint enrollment with TalkBack has not been tested.** It uses Android's standard enrollment screens, which are designed to work with TalkBack, but this hasn't been confirmed on this tablet.
- **Some troubleshooting steps use ADB commands** in Command Prompt. These are optional, and they're always given as complete commands to copy.
- **The documentation is in English only.** Browser translation tools work on it, but there are no maintained translations.

Fingerprint unlock can itself be an accessibility aid: it's an alternative to typing a PIN for people who find that difficult. Note that Android still asks for the PIN once after every restart.

## Expectations for contributors

When you change the documentation:

- write in plain language and explain any technical term the first time it's used
- keep instructions as text; give any image a meaningful text description, and never put a step only in an image
- keep headings in order (don't skip levels) and use numbered lists for steps
- never rely on color alone to convey meaning
- give link text that makes sense on its own (not "click here")

## Reporting an accessibility barrier

If something in this project is hard or impossible for you to use, please [open an issue](https://github.com/tomtombombadil/SM-T713-LineageOSv22_2-Fingerprint-Sensor/issues/new) and add the **accessibility** label if you can. Describe what you were trying to do, what got in the way, and any assistive technology you use. Problems with TWRP, Magisk or LineageOS themselves are best reported to those projects as well.

## Ownership and maintenance

The maintainer, [tomtombombadil](https://github.com/tomtombombadil), is responsible for accessibility in this project. This page is reviewed with each new release, and updated whenever a barrier is found or fixed.

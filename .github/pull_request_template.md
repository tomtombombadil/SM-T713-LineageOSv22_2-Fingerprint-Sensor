## What does this change?

<!-- Describe the change and why it's needed. Link the issue it fixes, for example "Fixes #12". -->

## How was it tested?

<!-- Which tablet, ROM build, TWRP and Magisk versions did you test on? What did you check? -->

- Tablet: SM-T713
- LineageOS build:
- TWRP version:
- Magisk version:

## Checklist

- [ ] I tested this on a real SM-T713.
- [ ] No Samsung proprietary files are added.
- [ ] Scripts and `.rc` / `.rule` / `.prop` files still have Unix (LF) line endings.
- [ ] The uninstall zip still undoes everything the install zip changes.
- [ ] If the zips changed: I rebuilt them and updated `filelist.txt`, `SHA256SUMS`, and the checksums in the README.
- [ ] If this affects the gatekeeper (PIN checker), I explained whether users must remove their PIN before updating.
- [ ] I updated the README if the instructions changed.

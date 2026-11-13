#!/system/bin/sh
# Belt and braces: apply the same rules live in case sepolicy.rule was not loaded at boot.
# This runs before the gatekeeper and fingerprint services start.
magiskpolicy --live --apply "${0%/*}/sepolicy.rule"

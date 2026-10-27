# Loving Brain — Web Server Setup for Invitation Links

This directory contains the files needed to make `https://www.lovingbrain.com/{invitationId}` work in web browsers (e.g. desktop Chrome, or mobile browsers when the app is not installed yet).

---

## What was Happening (Why 404 Occurred)

- The email button links to `https://www.lovingbrain.com/{invitationId}`.
- On a mobile device with **Loving Brain** installed, Android App Links / iOS Universal Links intercept this link and open the Flutter app directly.
- **However**, if clicked on a **desktop computer** or on a **phone that does not have the app installed yet**, the browser makes an HTTP request to `https://www.lovingbrain.com/{invitationId}`.
- Because `lovingbrain.com`'s web server has no file at `/{invitationId}`, Apache returned its default `404 File Not Found` error.

---

## 1-Minute Fix: Deploying to Web Server (`lovingbrain.com`)

Upload the two files in this folder to the root directory (usually `public_html/`) of your web server for `www.lovingbrain.com`:

1. **`invite.html`** → Place directly in `public_html/invite.html`.
2. **`.htaccess`** → Place directly in `public_html/.htaccess`.

### What it does:
- Any visitor to `https://www.lovingbrain.com/{invitationId}` is seamlessly served `invite.html`.
- On **Android / iOS**:
  - Automatically tries to open the mobile app via `lovingbrain://invite/{invitationId}`.
  - If the app is not installed, displays one-tap download buttons for **Google Play** and the **Apple App Store**.
- On **Desktop**:
  - Displays a clean, branded card with a **scannable QR code** so the parent can point their smartphone camera at the screen and instantly open the invitation in the mobile app.

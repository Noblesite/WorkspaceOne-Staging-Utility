# StagingComplete – iOS Utility for Workspace ONE

**StagingComplete** is a lightweight utility designed for Workspace ONE environments to streamline the final step of staging iOS devices. It enables third-party staging teams to complete device setup and move devices into their final organization group (OG) using MDM-managed app configuration and REST APIs.

This app is ideal for use in staging org groups where restrictions like Single App Mode or Kiosk Lockdown should not be applied until device prep is fully complete.

---

## ✅ Use Cases

- Finalize setup after 3rd-party staging (COPE or BYOD)
- Dynamically reassign devices to their production OG
- Avoid applying restrictions too early in the device staging lifecycle
- Repair network profiles before OG transition (optional)

---

## ⚙️ Features

### 🔐 Secure App Configuration Input
- Accepts all config data via MDM app configuration
- No hardcoded environment or OG values

### 🔐 Secure Configuration
- All config values passed via Managed App Config:
  - `staging_og_id`
  - `production_og_id`
  - `device_serial_number`
  - `auth_token` or `staging_account`
  - `airwatch_server_url`

### 🧩 Organization Group Transition
- Moves device from staging OG to production OG
- Uses Workspace ONE REST API with pre-populated credentials
- Logs success/failure via console/debug view

### 📶 Network Repair
- Optional Wi-Fi profile re-installation
- Uses SimplePing and X509 checks to validate and repair network payload
- Ideal for certificate-based Wi-Fi environments

### 🕹 Kiosk Mode Safe
- Final OG can enforce Single App Mode or restrictions
- App ensures all permissions are granted before the switch

---

## 🛠 Requirements

- iOS 13+
- Workspace ONE UEM (REST API enabled)
- Scoped to staging org group via MDM

---

## 🚀 Setup

1. Deploy the app to your staging OG with MDM-managed config
2. Pre-populate necessary config values
3. Ensure network profile is assigned to staging OG
4. Upon staging completion, press the "Lock Device" button to:
    - Move device to its final destination
    - Trigger all downstream policies (restrictions, kiosk, etc.)

---

## 📄 License

Internal use only (or MIT if publicly shared)

---

_Staging is done. Lock it down._

# docs/app-review.md

## Ling — App Store Review Risk Notes (MVP)

> This document exists to **prevent App Store rejection**.
> All implementation decisions must respect this guidance.

---

## 1. Use of LLM APIs

* Clearly disclose in App description:

  * User text may be sent to third-party LLM providers
* Do **not** log user text
* Do **not** collect analytics in MVP

---

## 2. API Key Handling

* API keys must:

  * Be entered explicitly by user
  * Be stored in Keychain
* No bundled keys
* No hidden defaults

---

## 3. Translation Extension Behavior

* Extension UI must:

  * Be fast
  * Be minimal
  * Clearly indicate it is Ling

* Do not:

  * Override system UI
  * Mimic Apple system dialogs visually

---

## 4. Default Translation App Claim

If claiming “can be used as default translation app”:

* Phrase carefully:

  * “Ling can be selected as your default translation app on supported iOS versions”
* Never imply system modification or replacement

---

## 5. Permissions

* Only request permissions that are strictly necessary
* No background processing
* No clipboard polling in background

---

## 6. Content Safety

* Do not attempt to filter or modify user input
* LLM output must be shown as-is
* Provide basic error messaging on failures

---

## 7. Subscription / Payments

* MVP must not reference:

  * Subscriptions
  * Payments
  * Trials

---

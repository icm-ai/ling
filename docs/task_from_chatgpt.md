# docs/tasks.md

## Ling MVP — Codex Task Breakdown

> This document is written **for code-generation agents (e.g. Codex)**.
> Tasks must be executed **top-down, in order**, without skipping steps.

---

## 0. Global Rules (Must Read First)

* Do **not** add features not listed in README.md
* Prefer **simple, explicit implementations**
* Optimize for **clarity and correctness**, not cleverness
* All UI must be functional before polishing
* No mock data in final MVP

---

## 1. Project Initialization

### Task 1.1 — Create iOS Project

* Create a new iOS app project
* Language: Swift
* UI Framework: SwiftUI
* Deployment target: iOS (latest stable)
* App name: `Ling`
* Bundle identifier: `com.example.ling` (placeholder, changeable)

---

### Task 1.2 — Project Structure

Create the following base structure:

```text
Ling/
├─ App/
│  ├─ LingApp.swift
│  └─ RootView.swift
├─ Features/
│  ├─ Read/
│  ├─ Saved/
│  └─ Settings/
├─ Services/
│  ├─ TranslationService.swift
│  ├─ LLMClient.swift
│  └─ PromptBuilder.swift
├─ Storage/
│  ├─ SavedItem.swift
│  └─ PersistenceController.swift
├─ Shared/
│  └─ AppConfig.swift
```

No additional folders unless strictly necessary.

---

## 2. Core Data & Persistence

### Task 2.1 — Define SavedItem Model

Fields:

* `id: UUID`
* `originalText: String`
* `translatedText: String`
* `createdAt: Date`
* `source: String?`

Implement local persistence using:

* Core Data **or**
* SQLite / lightweight persistence

Must support:

* Insert
* Fetch (sorted by date desc)

---

## 3. Translation Logic

### Task 3.1 — AppConfig (Shared Configuration)

Implement a shared configuration object containing:

* API base URL
* Model name
* Default prompt text
* Provider type enum

Config must be:

* Editable from Settings UI
* Readable by system extensions (via App Group later)

---

### Task 3.2 — LLMClient

Implement a generic HTTP client that:

* Sends text + prompt to an OpenAI-compatible API
* Accepts:

  * endpoint
  * model
  * apiKey
* Returns translated text (String)

Must handle:

* Network errors
* Invalid responses
* Timeout

No retries in MVP.

---

### Task 3.3 — TranslationService

Responsibilities:

* Accept raw input text
* Assemble final prompt
* Call `LLMClient`
* Return translated result

No caching in MVP.

---

## 4. Main App UI

### Task 4.1 — Root Tab View

Implement a `TabView` with **exactly three tabs**:

* Read
* Saved
* Settings

No badges, no extra navigation layers.

---

### Task 4.2 — Read Tab

UI elements:

* Multi-line text input
* “Translate” button
* Translation result area
* “Save” button (hidden until translation exists)

Behavior:

* On app foreground, read clipboard text
* Allow user to overwrite clipboard content
* Trigger translation via TranslationService

---

### Task 4.3 — Save Translation

When user taps “Save”:

* Persist `SavedItem`
* Show lightweight confirmation
* Do not navigate away

---

### Task 4.4 — Saved Tab

UI:

* List of saved items (latest first)

Interaction:

* Tap item → detail view
* Show original text + translation
* No editing in MVP

---

### Task 4.5 — Settings Tab

Required sections:

1. Translation Provider

   * API base URL
   * Model name
2. API Key Input

   * Stored securely in Keychain
3. Prompt Editor

   * Multiline text editor
4. Export

   * Export saved items to JSON or Markdown

No advanced presets in MVP.

---

## 5. System Extensions

### Task 5.1 — Action Extension

Create an Action Extension target:

* Accept selected text
* Display minimal UI:

  * Original text
  * Translated text
  * Save / Close buttons

Rules:

* Read config via App Group
* Read API key from Keychain
* No Settings UI here

---

### Task 5.2 — Data Sharing

Implement App Group:

* Share:

  * Saved items
  * AppConfig
* Ensure both main app and extension can write saved items

---

## 6. MVP Validation Checklist

Codex must ensure:

* App launches without crash
* Translation works with real API
* Saving works
* Saved items persist across launches
* Action Extension successfully translates selected text

---
# ling

Ling 不是翻译 App，而是“阅读中自然生长的语言学习工具”。

---

# Ling — iOS Reading-first Translation & Language Learning App (MVP Spec)

## 1. Project Overview

**Ling** is an iOS application focused on **text translation during reading** and **passive language learning**.

The core idea:

> Translation should be seamless during reading,
> and learning should be a natural byproduct, not a forced workflow.

Ling is designed primarily for **users reading long-form text** (e.g. books in Apple Books) who want:

* Higher-quality sentence / paragraph translation than the system default
* The ability to use **custom LLM translation models**
* To save translations as reusable learning material

---

## 2. MVP Scope Definition

### 2.1 In Scope (MVP must include)

#### Core Capabilities

1. **Text translation**

   * Input: plain text (word / sentence / paragraph)
   * Output: translated text
   * Translation powered by **user-configured LLM API**

     * Example providers: OpenAI-compatible API, DeepSeek-compatible API

2. **System-level usage**

   * Ling can be set as the **default iOS translation app** (where supported by OS)
   * Ling also provides an **Action Extension** as a fallback / compatibility path

3. **Learning by saving**

   * Any translation result can be saved
   * Saved items are reviewable later inside the app

4. **Minimal UI**

   * No gamification
   * No tasks, reminders, or study plans
   * Focus on reading → translating → saving → reviewing

---

### 2.2 Explicitly Out of Scope (MVP must NOT include)

* ❌ Speech / TTS
* ❌ Pronunciation scoring
* ❌ Flashcards or spaced repetition
* ❌ Social features
* ❌ Built-in content discovery
* ❌ User accounts / cloud sync
* ❌ Paid subscription logic

---

## 3. User Experience Model

Ling has **three logical states**, not three learning modes:

```
Reading → Translating → Reviewing
```

These states map directly to UI surfaces.

---

## 4. App Structure (High-Level)

### 4.1 Main App Tabs

The main app uses **three tabs only**:

```
[ Read ]   [ Saved ]   [ Settings ]
```

No additional tabs are allowed in MVP.

---

### 4.2 Read Tab

**Purpose:**
Provide a lightweight place to translate text manually or via clipboard.

**Core behavior:**

* Auto-detect text from clipboard when app becomes active
* Allow user to paste or edit text
* Trigger translation using the configured default model

**UI elements (minimum):**

* Text input area
* “Translate” button
* Translation result view
* “Save” button (appears after translation)

---

### 4.3 Saved Tab

**Purpose:**
Allow users to review translations they have chosen to save.

**Data structure:**

* Saved items contain:

  * Original text
  * Translated text
  * Timestamp
  * Optional source metadata (string)

**UI behavior:**

* List view ordered by recency
* Tapping an item shows full original + translation
* No forced tagging or annotation

---

### 4.4 Settings Tab

**Purpose:**
All complexity lives here.

**Required settings:**

1. **Translation Provider**

   * Provider type (OpenAI-compatible, DeepSeek-compatible, etc.)
   * API base URL
   * Model name
2. **API Key Management**

   * Stored securely (Keychain)
3. **Prompt Configuration**

   * Default translation prompt
4. **Export**

   * Export saved items as JSON or Markdown (basic)

Settings must be **fully functional before system extensions are used**.

---

## 5. System Integration

### 5.1 Default Translation App (Primary Path)

Where supported by iOS:

* Ling registers as a **system translation provider**
* User can select Ling as default translation app via:

  ```
  Settings → Apps → Default Apps → Translation → Ling
  ```

**Behavior:**

* When user selects text in supported apps (e.g. Apple Books)
* Chooses “Translate”
* Ling’s translation UI is invoked
* Translation uses:

  * The default model
  * The default prompt
  * Previously configured API key

No configuration UI should appear during this flow.

---

### 5.2 Action Extension (Fallback Path)

An **Action Extension** must be implemented to ensure:

* Compatibility with older iOS versions
* Compatibility with apps that do not route through default translation

**Behavior:**

1. User selects text
2. Chooses “Ling” from the action menu
3. A minimal Ling UI appears:

   * Original text
   * Translation result
   * Save / Close actions

The extension must:

* Read shared configuration (App Group)
* Never request API key input
* Never expose advanced settings

---

## 6. Translation Logic

### 6.1 Prompt Strategy (MVP)

The system uses **one default prompt**, configurable by the user.

Example prompt concept (illustrative only):

> You are a professional language translator.
> Translate the following text faithfully, preserving sentence structure.
> Prefer natural expression over literal translation.

Prompt text is treated as opaque configuration and passed directly to the LLM.

---

### 6.2 Request Flow

```
Text Input
   ↓
Prompt Assembly
   ↓
HTTP Request to LLM API
   ↓
Translation Result
   ↓
UI Display
```

Error handling must include:

* Network errors
* API errors
* Timeout fallback messaging

---

## 7. Data Storage

### 7.1 Saved Items

* Stored locally on device
* Use lightweight persistent storage (e.g. Core Data or SQLite)
* Shared access between:

  * Main App
  * Action Extension
  * Translation Provider (if applicable)

### 7.2 Sensitive Data

* API keys stored in Keychain
* Accessed read-only by extensions
* Never logged or exported

---

## 8. Technical Constraints

### Platform

* iOS
* Swift
* SwiftUI

### Architecture

* Modular
* Clear separation between:

  * UI
  * Translation logic
  * Persistence
  * System extensions

### Non-goals

* No backend server
* No analytics
* No user tracking

---

## 9. MVP Completion Criteria

The MVP is considered complete when:

1. User can configure an LLM translation provider
2. User can translate text inside the app
3. User can save and review translations
4. User can invoke Ling from system text selection (default translation or action extension)
5. No critical crashes or blocking UX issues exist

---

## 10. Guiding Philosophy (Do Not Violate)

* Translation must feel **instant and invisible**
* Learning must feel **optional and passive**
* Any feature that requires the user to “decide to study” is out of scope

---

## 11. Future Work (Non-binding)

These are explicitly **not part of MVP** and should not influence initial architecture decisions:

* Multiple prompts per language
* Offline translation models
* Cloud sync
* Vocabulary analysis
* Reading statistics

---

## End of Specification

This document defines the **authoritative MVP scope** for Ling.
All implementation work must align with this specification unless explicitly revised.

---

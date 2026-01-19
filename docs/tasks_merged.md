# Ling MVP Implementation Roadmap (Merged & Optimized)

> **Role**: iOS Engineering Expert
> **Goal**: A lean, structured task list optimized for agentic execution, following Occam's Razor.
> **Tech Stack**: SwiftUI, SwiftData (iOS 17+), OpenAI-Compatible API.

---

## 0. Global Rules (Must Respect)
- **Simplicity**: No third-party dependencies unless strictly necessary. Reach for `URLSession` and `SwiftData`.
- **Privacy & Compliance**: 
    - No analytics, no background clipboard polling.
    - User must provide their own API Key.
    - Securely store keys in Keychain.
- **Data Sharing**: Use App Groups to share data between the Main App and Action Extension.

---

## 1. Project Initialization & Infrastructure
*Goal: Establish the shared data layer and project structure.*

- [ ] **1.1 Workspace Setup**
    - [ ] Create iOS App Project (`Ling`).
    - [ ] Configure `App Group` (e.g., `group.com.yourname.ling`).
    - [ ] Set up the following directory structure:
        ```text
        Sources/Ling/
        ├─ App/             # App Lifecycle & Root
        ├─ Core/            # Shared logic (SwiftData models, LLMClient, Keychain)
        ├─ Features/        # UI Tabs (Read, Saved, Settings)
        └─ Extensions/      # Action Extension
        ```
- [ ] **1.2 Shared Security (Keychain)**
    - [ ] Implement a minimal `KeychainManager` accessible by the App Group.
    - [ ] Store/Retrieve `apiKey`.
- [ ] **1.3 Data Persistence (SwiftData)**
    - [ ] Define `@Model class SavedItem`: `id`, `originalText`, `translatedText`, `createdAt`, `source`.
    - [ ] Configure `ModelContainer` to use a shared SQLite file in the App Group directory.

---

## 2. Translation Core (The "Brain")
*Goal: Implement logic independent of the UI.*

- [ ] **2.1 LLM Client**
    - [ ] Build a generic `LLMClient` (OpenAI compatible).
    - [ ] Function: `translate(text: String, config: AppConfig) async throws -> String`.
    - [ ] Handle errors: 401 (Auth), 429 (Rate), Timeout.
- [ ] **2.2 Configuration Model**
    - [ ] Define `AppConfig` (Codable): `baseURL`, `modelName`, `promptTemplate`.
    - [ ] Ensure `AppConfig` is stored in `UserDefaults(suiteName: "your_group_id")`.

---

## 3. Settings & Configuration UI
*Goal: Make the app functional by allowing API setup.*

- [ ] **3.1 Settings View**
    - [ ] Fields: API Base URL, Model Name, API Key (Secure Field), Prompt Editor.
    - [ ] "Test Connection" button to verify the setup.
- [ ] **3.2 Shared State Management**
    - [ ] Ensure changes in Settings are immediately available to other modules.

---

## 4. Main App Experience
*Goal: Implement the primary user flow.*

- [ ] **4.1 Read Tab**
    - [ ] Implement "Smart Clipboard": On app foreground, check for text and offer translation.
    - [ ] Minimalist UI: Input area, Translate button, Result area.
    - [ ] "Save" button to persist the result to SwiftData.
- [ ] **4.2 Saved Tab**
    - [ ] List View: Show history sorted by `createdAt`.
    - [ ] Detail View: View full original text and translation.
    - [ ] Action: Swipe to delete.

---

## 5. System Integration (Action Extension)
*Goal: Translate from any app (e.g., Safari, Apple Books).*

- [ ] **5.1 Extension Setup**
    - [ ] Create `Action Extension` target.
    - [ ] Configure to accept `public.text`.
- [ ] **5.2 Extension UI & Logic**
    - [ ] Minimal SwiftUI overlay (matches system feel).
    - [ ] Logic: Read config/key -> Translate -> Display -> Option to "Save" to shared SwiftData.

---

## 6. Export & Final Polish
*Goal: Utility and App Store readiness.*

- [ ] **6.1 Data Export**
    - [ ] Implement "Export all to JSON/Markdown" in Settings.
- [ ] **6.2 Compliance Check**
    - [ ] Verify no background polling.
    - [ ] Ensure error messages are helpful but simple.
    - [ ] Disclose 3rd party API usage in app metadata (placeholder for now).

---

## 7. Validation Checklist
- [ ] App launches and SwiftData initializes in App Group.
- [ ] Connection test passes with a real API key.
- [ ] Extension can translate and save an item that appears in the Main App's list.
- [ ] Memory/Performance: App feels snappy; no leaks.

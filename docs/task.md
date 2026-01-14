# Ling MVP Implementation Roadmap (Codex-Friendly)

> **Role**: iOS Engineering Expert + Codex Design
> **Goal**: A structured, sequential task list optimized for agentic execution. Each phase depends on the previous one.

---

## Phase 1: Foundation & Shared Infrastructure
*Goal: Establish the shared data layer needed for App Groups and Extensions.*

- [ ] **1.1 Project Scaffolding & App Groups**
    - [ ] Create iOS App Project (`Ling`).
    - [ ] Configure `App Group` (e.g., `group.com.yourname.ling`) for data sharing.
    - [ ] Set up a modular folder structure: `Core/`, `Features/`, `UI/`, `Extensions/`.
- [ ] **1.2 Security & Configuration (Shared)**
    - [ ] Implement `KeychainManager` (accessible via App Group) for secure API Key storage.
    - [ ] Define `AppConfig` struct to handle Provider Type, Base URL, Model, and Prompt.
- [ ] **1.3 Persistence Layer (Shared)**
    - [ ] Set up `Core Data` (or SQLite) stack using a shared container in the App Group directory.
    - [ ] Define `SavedItem` Entity: `id`, `originalText`, `translatedText`, `timestamp`, `source`.

## Phase 2: Translation Service Core
*Goal: Implement the "Brain" logic independent of the UI.*

- [ ] **2.1 LLM Provider Client**
    - [ ] Build a generic `LLMClient` supporting OpenAI-compatible protocols.
    - [ ] Implement `translate(text:config:)` async function.
    - [ ] Handle standard error cases (401 Unauthorized, 429 Rate Limit, Network Timeout).
- [ ] **2.2 Prompt Engineering Model**
    - [ ] Create `PromptTemplate` to wrap user input with system instructions.

## Phase 3: Settings & Configuration UI
*Goal: Make the app functional by allowing user input of API credentials.*

- [ ] **3.1 Settings Tab**
    - [ ] UI for selecting Provider (OpenAI/DeepSeek).
    - [ ] Form for API URL, Model Name, and Default Prompt.
    - [ ] Secure input for API Key (saving to Keychain).
- [ ] **3.2 Settings Validation**
    - [ ] Add a "Test Connection" button to verify API setup.

## Phase 4: Basic Reading & Saving (Main App)
*Goal: Implement the core loops within the main app.*

- [ ] **4.1 Read Tab UI**
    - [ ] Implement `ClipboardMonitor` to detect and suggest translation when app opens.
    - [ ] Text editor for manual input.
    - [ ] Translation state management (Idle -> Loading -> Success/Error).
- [ ] **4.2 Save & Review Loop**
    - [ ] Implement "Save" button to persist results to Core Data.
    - [ ] **Saved Tab**: Implement a list view sorted by date.
    - [ ] Detail view for viewing/copying saved translations.

## Phase 5: System Integration (Action Extension)
*Goal: Enable translation from any app (e.g., Apple Books).*

- [ ] **5.1 Action Extension Setup**
    - [ ] Create `Action Extension` target.
    - [ ] Configure it to accept `public.text` types.
- [ ] **5.2 Extension UI & Logic**
    - [ ] Minimal SwiftUI overlay for the extension.
    - [ ] Logic to read Shared Keychain/Config and invoke `LLMClient`.
    - [ ] "Save" action within the extension that directly writes to the shared Core Data store.

## Phase 6: iOS System Translation (Optional/Advanced)
*Goal: Native integration where supported.*

- [ ] **6.1 Translation Provider Target**
    - [ ] Add `Translation Provider` extension (iOS 17.4+ or 18.0+ specific APIs if available).
    - [ ] Register Ling as a system translator.

## Phase 7: Polish & Export
*Goal: Utility and UX refinement.*

- [ ] **7.1 Export Feature**
    - [ ] implementation of "Export all" as JSON/Markdown in Settings.
- [ ] **7.2 Error UX**
    - [ ] Refined toast notifications or alerts for failed API calls.

---

## Development Guidelines for Codex
1. **Shared First**: Always ensure logic added to `Core/` or `Services/` is accessible by both the App and the Extensions.
2. **SwiftUI First**: Use `@Observable` (iOS 17+) or `ObservableObject` for state.
3. **No Placeholders**: Every implementation should aim for "Production-ready" error handling from the start.
4. **App Group Verification**: After Phase 1, every save/load should be verified to work across process boundaries.

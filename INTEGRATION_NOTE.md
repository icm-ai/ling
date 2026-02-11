# Project Integration Notes

## Status Update (2026-01-31)
The project structure has been reorganized to resolve git conflicts and package visibility issues.

### 1. Structure
- `LingPackage/`: Contains the Swift Package (Sources, Package.swift).
- `Ling.xcodeproj`: Main app project.
- `Ling/`: Contains app-specific sources (LingApp.swift, Assets).

### 2. Git
- Consolidated into a single repository at the root.
- Nested `.git` directories removed.
- Use `git commit` to save the structural changes.

### 3. Required Manual Step
The Swift Package `LingPackage` is linked to the Project, but the Library `LingApp` needs to be added to the Target:
1. Open `Ling.xcodeproj`.
2. Select `Ling` Target -> `General`.
3. Under **Frameworks, Libraries, and Embedded Content**, click `+`.
4. Select `LingApp` (from LingPackage) -> Add.

### 4. App Groups
- Configuration verified in `Ling.entitlements`.

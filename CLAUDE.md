# NavigationLibrary

## Project Overview

Swift Package Manager library providing a coordinator-based navigation system for SwiftUI. Targets iOS 18+ with Swift 6.0 strict concurrency.

## Repository Structure

```
NavigationLibrary/
├── Package.swift                    # SPM manifest (iOS 18+, Swift 6.0)
├── Sources/NavigationLibrary/
│   ├── Coordinators/
│   │   ├── AppCoordinator/          # Top-level coordinator aggregating all sub-coordinators
│   │   ├── Navigation/              # Push/pop navigation (NavigationStack)
│   │   ├── Sheet/                   # Stackable sheet presentation
│   │   ├── Tab/                     # Tab selection management
│   │   └── Alert/                   # Alert presentation with stacking support
│   ├── Router/                      # RouterProtocol, RouterContext (facade over coordinators)
│   ├── Models/                      # AlertAction, TitleAndMessageType
│   └── Helpers/                     # AnimatedCoordinator, HashableProtocol
├── Tests/NavigationLibraryTests/
└── Example/FullNavigation/          # Demo app (separate Xcode project, imports NavigationLibrary)
```

## Architecture

### Core Pattern: Coordinator + Route + Type Erasure

1. **Routes** define destinations via protocols: `NavigationRoute`, `SheetRoute`, `TabRoute` (all extend `Route`)
2. Each route provides a `destinationView` and is `Hashable`
3. Routes are type-erased (`erased()` → `AnyNavigationRoute`, `AnySheetRoute`, `AnyTabRoute`) for internal storage
4. **Coordinators** manage state: `NavigationCoordinator` (path), `SheetCoordinator` (sheet stack), `TabCoordinator` (selected tab), `AlertCoordinator` (alert queue)
5. **`RouterProtocol`** provides convenience methods (`push`, `pop`, `showSheet`, `hideSheet`, `selectTab`, `showAlert`) that delegate to the appropriate coordinator via `RouterContext`
6. **`AppCoordinator`** groups `SheetCoordinator`, `AlertCoordinator`, and `TabCoordinator` as a single entry point

### Key Design Decisions

- **@Observable** (not Combine) for all state management
- **Type erasure** is internal — consumers work with typed `Route` conformances, never with `Any*Route` directly
- **AnimatedCoordinator** protocol provides `execute(animated:action:)` to optionally disable animations via `withTransaction`
- **HashableProtocol** provides identity-based `Equatable`/`Hashable` for reference-type coordinators
- **Sheets are stackable** — `SheetStackModifier` recursively nests `.sheet` modifiers to support multiple stacked sheets
- **`AnyRoute` protocol** is internal; its `==` and `hash` must remain `public` because public types (`AnySheetRoute`) conform through it

### Access Control Convention

- `public` only on types/members that the consumer module needs
- Type-erased wrappers (`AnyNavigationRoute`) and `erased()` methods are `internal` — they're implementation details
- `ActionInfo`, `ActionView` are `internal` — only used by `CustomAlertModifier`
- Internal protocols (`AnyRoute`, `AnimatedCoordinator`, `HashableProtocol`) can have `public` extension methods when they provide conformance for public types

## Example App (FullNavigation)

The Example app demonstrates the library's usage pattern:

- **Builder pattern**: `BuilderProtocol` + `PayloadProtocol` for scene construction
- **Router per scene**: Each scene has a dedicated router (e.g., `HomeRouter: RouterProtocol`) that encapsulates navigation logic
- **Scene/ViewModel separation**: `HomeScene` (View) + `HomeSceneModel` (@Observable)
- Routes are enums conforming to `NavigationRoute` or `SheetRoute`

## Build & Test

```bash
# Build the library
swift build

# Run tests
swift test
```

Or use Xcode: open `Package.swift`, build with Cmd+B, test with Cmd+U.

The Example app (`Example/FullNavigation`) is a separate Xcode project that depends on the local package.

## Code Style

- **4-space indentation**
- **PascalCase** for types, **camelCase** for properties/methods
- **@Observable** classes, never Combine
- **Swift concurrency** (async/await) over Combine
- **Testing framework** for unit tests (not XCTest)
- No force unwrapping
- Prefer `let` over `var`
- `public` only where necessary for cross-module access
- ViewModifiers exposed via View extensions (e.g., `.stackableSheets(coordinator:)`, `.alert(coordinator:)`)

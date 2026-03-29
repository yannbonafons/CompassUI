# CompassUI

## Project Overview

Swift Package Manager library providing a coordinator-based navigation system for SwiftUI. Targets iOS 18+ with Swift 6.0 strict concurrency.

## Repository Structure

```
CompassUI/
├── Package.swift                    # SPM manifest (iOS 18+, Swift 6.0)
├── Sources/CompassUI/
│   ├── Coordinators/
│   │   ├── AppCoordinator/          # Top-level coordinator aggregating all sub-coordinators
│   │   ├── Navigation/              # Push/pop navigation (NavigationStack) + NavigationContainerView
│   │   ├── Sheet/                   # Stackable sheet presentation
│   │   ├── Tab/                     # Tab selection management
│   │   ├── Alert/                   # Alert presentation with stacking support
│   │   └── ExternalLinks/           # Deeplink & universal link handling (ExternalLinkRoute, ExternalLinkModifier)
│   ├── Router/                      # Route, RouterProtocol, RouterContext (facade over coordinators)
│   ├── Models/                      # AlertAction, TitleAndMessageType
│   └── Helpers/                     # AnimatedCoordinator, HashableProtocol
├── Tests/CompassUITests/
└── ExampleNavigationApp/           # Demo app (separate Xcode project, imports CompassUI)
```

## Architecture

### Core Pattern: Coordinator + Route + Type Erasure

1. **Routes** define destinations via protocols: `NavigationRoute`, `SheetRoute`, `TabRoute`, `ExternalLinkRoute` (all extend `Route` or `SheetRoute`)
2. Each route provides a `destinationView` and is `Hashable`
3. Routes are type-erased (`erased()` → `AnyNavigationRoute`, `AnySheetRoute`, `AnyTabRoute`) for internal storage
4. **Coordinators** manage state: `NavigationCoordinator` (path), `SheetCoordinator` (sheet stack), `TabCoordinator` (selected tab), `AlertCoordinator` (alert queue)
5. **`RouterProtocol`** provides convenience methods (`push`, `pop`, `popToRoot`, `showSheet`, `hideSheet`, `hideSheet(_ route:)`, `hideAll`, `selectTab`, `showAlert`) that delegate to the appropriate coordinator via `RouterContext`
6. **`AppCoordinator`** groups `SheetCoordinator`, `AlertCoordinator`, and `TabCoordinator` as a single entry point
7. **`NavigationContainerView`** wraps `NavigationStack` + `navigationDestination`, creates its own `NavigationCoordinator` and passes `RouterContext` to the content closure
8. **`ExternalLinkRoute`** enables deeplink/universal link resolution — routes conforming to it implement `static func resolve(url:context:)` and are presented as sheets via `ExternalLinkModifier`

### Key Design Decisions

- **@Observable** (not Combine) for all state management
- **Type erasure** is internal — consumers work with typed `Route` conformances, never with `Any*Route` directly
- **AnimatedCoordinator** protocol provides `execute(animated:action:)` to optionally disable animations via `withTransaction`
- **HashableProtocol** provides identity-based `Equatable`/`Hashable` for reference-type coordinators
- **Sheets are stackable** — `SheetStackModifier` recursively nests `.sheet` modifiers to support multiple stacked sheets
- **`SheetCoordinatorProtocol`** (public) exposes `hideSheet()` for consumers; **`StackableSheetProtocol`** (public) exposes `sheetRoutes` for `SheetStackModifier`
- **`AnyRoute` protocol** is internal; its `==` and `hash` must remain `public` because public types (`AnySheetRoute`) conform through it
- **`RouterContext.mockValue`** provides a ready-made mock context for SwiftUI previews
- **`RouterGlobalContext`** groups app-level coordinators (sheet, alert, tab) — obtained via `AppCoordinator.globalContext` and passed to `NavigationContainerView` and `.externalLinks`

### Route Hashable Constraint

All routes must be `Hashable` (required by `NavigationPath`). Best practices for route payloads:

- **Prefer identifiers** — pass `itemId: String` or `userId: UUID`, not full model objects. The destination view resolves heavy data from a store/service.
- **If a non-Hashable payload is unavoidable**, implement `Hashable` based on a stable identity subset (e.g., the object's `id`), not the full object.
- **Sheets are not affected** — `SheetCoordinator` type-erases routes via `AnySheetRoute` with identity-based hashing; the payload itself is not hashed.

### Access Control Convention

- `public` only on types/members that the consumer module needs
- Type-erased wrappers (`AnyNavigationRoute`) and `erased()` methods are `internal` — they're implementation details
- `ActionInfo`, `ActionView` are `internal` — only used by `CustomAlertModifier`
- Internal protocols (`AnyRoute`, `AnimatedCoordinator`, `HashableProtocol`) can have `public` extension methods when they provide conformance for public types

## Example App (ExampleNavigationApp)

Located at `ExampleNavigationApp/ExampleNavigationApp/`, this is a separate Xcode project that depends on the local CompassUI package.

Scenes: **Home**, **Info**, **Settings** (3 tabs via `TabItem` enum).

### Patterns demonstrated

- **Builder pattern**: `BuilderProtocol` + `PayloadProtocol` for scene construction — `PayloadProtocol` carries a `RouterContext` and is associated with a `BuilderType`
- **Router per scene**: Each scene has a dedicated router protocol + struct (e.g., `HomeRouterProtocol` / `HomeRouter: RouterProtocol`) that encapsulates navigation logic
- **Scene/SceneModel separation**: `HomeScene` (View) + `HomeSceneModel` (@Observable) — SceneModel holds the router protocol (not the concrete type) for testability
- **ModalNavigationModifier**: `.asModal(coordinator:)` helper adds a cancel toolbar button to sheet-presented views
- Routes are enums conforming to `NavigationRoute` or `SheetRoute`
- Previews use `RouterContext.mockValue`

## Build & Test

```bash
# Build the library
swift build

# Run tests
swift test
```

Or use Xcode: open `Package.swift`, build with Cmd+B, test with Cmd+U.

The Example app (`ExampleNavigationApp/`) is a separate Xcode project that depends on the local package.

## Code Style

- **4-space indentation**
- **PascalCase** for types, **camelCase** for properties/methods
- **@Observable** classes, never Combine
- **Swift concurrency** (async/await) over Combine
- **Testing framework** for unit tests (not XCTest)
- No force unwrapping
- Prefer `let` over `var`
- `public` only where necessary for cross-module access
- ViewModifiers exposed via View extensions (e.g., `.stackableSheets(coordinator:)`, `.alert(coordinator:)`, `.externalLinks(_:globalContext:)`)

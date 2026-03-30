# CompassUI

A coordinator-based navigation library for SwiftUI.

CompassUI provides a set of coordinators that manage push navigation, stackable sheets, alerts with queuing, tab selection, and deeplink handling — all built on `@Observable` with no Combine dependency.

## Requirements

- iOS 17+
- Swift 6.0
- Xcode 26+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/yannbonafons/CompassUI", from: "1.0.0")
]
```

## Quick Start

### 1. Define your tabs

```swift
enum TabItem: TabRoute, CaseIterable {
    case home
    case settings
}
```

### 2. Set up the App with `AppCoordinator`

`AppCoordinator` groups the app-level coordinators (sheet, alert, tab). Each tab gets its own `NavigationContainerView`, which acts like a `UINavigationController` — it creates its own navigation stack and provides a `RouterContext` to its content.

```swift
@main
struct MyApp: App {
    @State var appCoordinator = AppCoordinator(selectedTab: TabItem.home,
                                               possibleTabs: TabItem.allCases)

    var body: some Scene {
        WindowGroup {
            TabView(selection: $appCoordinator.tabCoordinator.selectedTab) {
                Tab("Home", systemImage: "house", value: TabItem.home.erased()) {
                    NavigationContainerView(globalContext: appCoordinator.globalContext) { context in
                        HomeBuilder.createView(with: HomePayload(context: context))
                    }
                }
            }
            .stackableSheets(coordinator: appCoordinator.sheetCoordinator)
            .alert(coordinator: appCoordinator.alertCoordinator)
            .externalLinks(AppExternalLinkRoute.self,
                           globalContext: appCoordinator.globalContext)
        }
    }
}
```

> `.stackableSheets`, `.alert`, and `.externalLinks` must be applied **once**, high in the view hierarchy (e.g., on the root `TabView`).

### 3. Define routes

**Navigation routes** (push):

```swift
enum HomeRoute: NavigationRoute {
    case detail(itemId: String)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .detail(let itemId):
            DetailView(itemId: itemId)
        }
    }
}
```

**Sheet routes** (modal) — the `RouterContext` must be forwarded so the new navigation stack shares the same global coordinators:

```swift
enum HomeSheetRoute: SheetRoute {
    case settings(context: RouterContext)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .settings(let context):
            NavigationContainerView(globalContext: context.globalContext) { context in
                SettingsView(context: context)
                    .asModal(coordinator: context.sheetCoordinator)
            }
        }
    }
}
```

### 4. Forward the context between screens

`RouterContext` must be passed from screen to screen so that every view shares the same coordinators. How you forward it is up to you — via a payload struct, `@Environment`, or any other mechanism.

```swift
// Screen A pushes Screen B → forward the context
func showDetail(itemId: String) {
    let payload = DetailPayload(itemId: itemId, context: context)
    push(.detail(payload: payload))
}
```

When opening a **new navigation** (e.g., a sheet), pass `context.globalContext` to `NavigationContainerView`. It will create a fresh `NavigationCoordinator` and provide a new `RouterContext` in its closure.

### 5. Create a Router (optional but recommended)

`RouterProtocol` provides typed convenience methods (`push`, `pop`, `showSheet`, `hideSheet`, `selectTab`, `showAlert`...) that delegate to the appropriate coordinator. Create one per scene for clean separation.

```swift
struct HomeRouter: RouterProtocol {
    typealias NavigationRouteType = HomeRoute
    typealias SheetRouteType = HomeSheetRoute

    let context: RouterContext

    func showDetail(itemId: String) {
        push(.detail(itemId: itemId))
    }

    func close() {
        hideSheet()
    }
}
```

You can also use the coordinators directly via `RouterContext` if you don't need the typed convenience layer.

### 6. Show alerts

Alerts are displayed one at a time. If `showAlert` is called while an alert is already visible, the new one is queued and shown after the current one is dismissed.

```swift
router.showAlert(AlertConfiguration(
    titleAndMessageType: .messageAndTitle(
        message: "Are you sure?",
        title: "Confirm"
    ),
    actions: [
        AlertAction(actionMessage: "Cancel", role: .cancel),
        AlertAction(actionMessage: "Delete", action: { _ in
            // handle delete
        }, role: .destructive)
    ]
))
```

## Architecture Overview

```
AppCoordinator (app-level)
├── SheetCoordinator      — stackable sheet presentation
├── AlertCoordinator      — alert queue (FIFO, one at a time)
└── TabCoordinator        — tab selection
        ↓ RouterGlobalContext
NavigationContainerView (one per tab)
└── NavigationCoordinator — push/pop navigation stack
        ↓ RouterContext (global + navigation)
```

- **`RouterGlobalContext`** = sheet + alert + tab coordinators, shared across all navigation stacks
- **`RouterContext`** = `RouterGlobalContext` + `NavigationCoordinator`, scoped to a single navigation stack
- **Sheets stack** on top of each other (managed at the `TabView` level, not per-screen)
- **Type erasure is internal** — you work with typed routes, never with `Any*Route`

## Route Payloads & Hashable

Navigation routes must be `Hashable` (required by `NavigationPath`). Best practices:

- **Prefer identifiers** — pass `itemId: String` or `userId: UUID`, not full model objects. The destination view resolves data from a store/service.
- **If a non-Hashable payload is unavoidable**, implement `Hashable` based on a stable identity (e.g., the object's `id`).
- **Sheets are not affected** — `SheetCoordinator` uses identity-based hashing internally.

## Deeplinks & Universal Links

Conform to `ExternalLinkRoute` and implement `resolve(url:context:)`. Matched routes are presented as sheets automatically.

```swift
enum AppExternalLinkRoute: ExternalLinkRoute {
    case info

    static func resolve(url: URL, context: RouterContext) -> Self? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        switch components.path {
        case "/info": return .info
        default: return nil
        }
    }

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info:
            InfoView()
        }
    }
}
```

## Previews

Use `RouterContext.mockValue` for SwiftUI previews:

```swift
#Preview {
    HomeBuilder.createView(with: HomePayload(context: RouterContext.mockValue))
}
```

## License

MIT

# CompassUI

A coordinator-based navigation library for SwiftUI.

CompassUI provides a set of coordinators that manage push navigation, stackable sheets, split view management (two or three columns), alerts with queuing, tab selection, and deeplink handling — all built on `@Observable` with no Combine dependency.

## Requirements

- iOS 17+
- Swift 6.2
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

> No tab bar in your app (or in a flow such as onboarding)? Skip to [Apps and flows without a tab bar](#8-apps-and-flows-without-a-tab-bar-lite-variants).

### 2. Set up the App with `AppCoordinator`

`AppCoordinator` groups the app-level coordinators (sheet, alert, tab). Each tab gets its own `NavigationContainerView`, which acts like a `UINavigationController` — it creates its own navigation stack and hands your content closure its `NavigationCoordinator`. You build the `RouterContext` yourself from that coordinator and the app's global context.

```swift
@main
struct MyApp: App {
    @State var appCoordinator = AppCoordinator(selectedTab: TabItem.home,
                                               possibleTabs: TabItem.allCases)

    var body: some Scene {
        WindowGroup {
            TabView(selection: $appCoordinator.tabCoordinator.selectedTab) {
                Tab("Home", systemImage: "house", value: TabItem.home.erased()) {
                    NavigationContainerView { navigationCoordinator in
                        HomeBuilder.createView(
                            with: HomePayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                     globalContext: appCoordinator.globalContext))
                        )
                    }
                }
            }
            .stackableSheetsAndAlert(sheetCoordinator: appCoordinator.sheetCoordinator,
                                     alertCoordinator: appCoordinator.alertCoordinator)
            .externalLinks(AppExternalLinkRoute.self,
                           globalContext: appCoordinator.globalContext)
        }
    }
}
```

> `.stackableSheetsAndAlert` and `.externalLinks` must be applied **once**, high in the view hierarchy (e.g., on the root `TabView`).

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

**Sheet routes** (modal) — a sheet opens a new navigation stack, so wrap its content in a `NavigationContainerView` and build a fresh `RouterContext` from the new `NavigationCoordinator` and the `globalContext` of the context that presents it. `NavigationContainerView` auto-applies `.asModal()`, so sheet-presented content automatically gets a cancel toolbar button that calls `hideSheet()`:

```swift
enum HomeSheetRoute: SheetRoute {
    case settings(settingsPayload: SettingsPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .settings(let payload):
            NavigationContainerView { navigationCoordinator in
                SettingsBuilder.createView(
                    with: SettingsPayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                 globalContext: payload.context.globalContext))
                )
            }
        }
    }
}
```

Sheets can be customized by providing a `configuration` (`SheetConfiguration`: detents, close button...).

#### Overriding the cancel action

By default the cancel button calls `hideSheet()`. If dismissal must run custom logic (saving a draft, showing a confirmation alert, etc.), apply `.onSheetCancel { ... }` **from inside the Scene** — the closure is published via a `PreferenceKey` and picked up by the modal toolbar, so the action lives next to its `ViewModel`:

```swift
struct SettingsScene: View {
    @State var model: SettingsSceneModel

    var body: some View {
        Form { ... }
            .onSheetCancel { model.saveDraft() }
    }
}
```

When set, the closure fully replaces the default `hideSheet()` behavior — call it explicitly if you still want to dismiss after your custom logic.

### 4. Forward the context between screens

`RouterContext` must be passed from screen to screen so that every view shares the same coordinators. How you forward it is up to you — via a payload struct, `@Environment`, or any other mechanism.

```swift
// Screen A pushes Screen B → forward the context
func showDetail(itemId: String) {
    let payload = DetailPayload(itemId: itemId, context: context)
    push(.detail(payload: payload))
}
```

When opening a **new navigation** (e.g., a sheet), read `context.globalContext` and build a new `RouterContext` inside a `NavigationContainerView`, as shown in the sheet route above. The container creates a fresh `NavigationCoordinator` for it.

### 5. Create a Router (optional but recommended)

`RouterProtocol` provides typed convenience methods (`push`, `pop`, `popToRoot`, `showSheet`, `hideSheet`, `hideAll`, `showAlert`) that delegate to the appropriate coordinator. Create one per scene for clean separation. It is generic over its context (`RouterContext` or `RouterContextLite`).

Associated types default to `EmptyRoute` — a no-op route conforming to `SheetRoute`, `NavigationRoute`, and `SplitRoute` at once — so a router only needs to specify the route types it actually uses.

Extra capabilities are opt-in through sub-protocols:

| Protocol | Adds | Requires |
|---|---|---|
| `RouterProtocol` | `push`, `pop`, `popToRoot`, `showSheet`, `hideSheet`, `hideAll`, `showAlert` | any context |
| `TabRouterProtocol` | `selectTab` | `RouterContext` (with tab bar) |
| `SplitRouterProtocol` | `showContent`, `dismissContent`, `showDetail`, `dismissDetail` | a context from a `SplitContainerView` |

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

You can also use the coordinators directly via the context if you don't need the typed convenience layer.

### 6. Show alerts

Alerts are displayed one at a time. If `showAlert` is called while an alert is already visible, the new one is queued and shown after the current one is dismissed.

Alerts are always presented from the top-most sheet (or the root view when no sheet is shown), so showing an alert never dismisses the sheet currently on screen.

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

### 7. Manage a split view

`SplitContainerView` is the split-view equivalent of `NavigationContainerView`: it wraps a `NavigationSplitView` and creates its own `SplitCoordinator`, which drives the content and detail columns. Two initializers mirror the native ones.

**Split routes** are presented in the content/detail columns. Wrap their content in a `NavigationContainerView` if the column needs its own navigation stack:

```swift
enum HomeSplitRoute: SplitRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let payload):
            NavigationContainerView { navigationCoordinator in
                InfoBuilder.createView(
                    with: InfoPayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                             globalContext: payload.context.globalContext))
                )
            }
        }
    }
}
```

**Two columns** (sidebar + detail) — a single `emptyView` placeholder is shown in the detail column when nothing is selected:

```swift
SplitContainerView(HomeSplitRoute.self) { splitCoordinator in
    NavigationContainerView { navigationCoordinator in
        HomeBuilder.createView(
            with: HomePayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                     splitCoordinator: splitCoordinator,
                                                     globalContext: appCoordinator.globalContext))
        )
    }
} emptyView: {
    AnyView(Text("Select an item"))
}
```

**Three columns** (sidebar + content + detail) — distinct placeholders for each column (both default to `EmptyView`):

```swift
SplitContainerView(HomeSplitRoute.self) { splitCoordinator in
    SidebarView(splitCoordinator: splitCoordinator)
} contentEmptyView: {
    AnyView(Text("Select a category"))
} detailEmptyView: {
    AnyView(Text("Select an item"))
}
```

Pass the `splitCoordinator` to the `RouterContext` of the scenes that need to drive the columns. Then make their router conform to `SplitRouterProtocol` and set `SplitRouteType`:

```swift
struct HomeRouter: SplitRouterProtocol {
    typealias SplitRouteType = HomeSplitRoute

    let context: RouterContext

    func showInfoAsDetail() {
        showDetail(.info(infoPayload: InfoPayload(context: context)))
    }
}
```

- `showContent(_:)` / `dismissContent()` drive the content column (three-column layout). Dismissing the content also clears the detail, which depends on it.
- `showDetail(_:)` / `dismissDetail()` drive the detail column and fall back to the empty placeholder.
- The compact column (iPhone, split-screen) follows automatically: `showContent` → content, `showDetail` → detail, `dismissDetail` → content (or sidebar if none is shown), `dismissContent` → sidebar.
- These calls are no-ops when the context has no `splitCoordinator` (i.e., it doesn't originate from a `SplitContainerView`).

### 8. Apps and flows without a tab bar (Lite variants)

For an app without tabs — or a flow that runs before the tab bar exists, such as onboarding or login — use the "Lite" counterparts. They are identical to their full versions minus the `TabCoordinator`:

| With tab bar | Without tab bar |
|---|---|
| `AppCoordinator` | `AppCoordinatorLite` |
| `RouterGlobalContext` | `RouterGlobalContextLite` |
| `RouterContext` | `RouterContextLite` |

`NavigationContainerView`, `SplitContainerView`, `RouterProtocol`, `SplitRouterProtocol`, `.stackableSheetsAndAlert` and `.externalLinks` work with both. Only `selectTab` (via `TabRouterProtocol`) requires the full `RouterContext`.

```swift
@main
struct MyApp: App {
    @State private var appCoordinatorLite = AppCoordinatorLite()

    var body: some Scene {
        WindowGroup {
            NavigationContainerView { navigationCoordinator in
                OnboardingBuilder.createView(
                    with: OnboardingPayload(context: RouterContextLite(navigationCoordinator: navigationCoordinator,
                                                                       globalContext: appCoordinatorLite.globalContext))
                )
            }
            .stackableSheetsAndAlert(sheetCoordinator: appCoordinatorLite.sheetCoordinator,
                                     alertCoordinator: appCoordinatorLite.alertCoordinator)
        }
    }
}
```

A router for a tab-less scene simply uses the lite context:

```swift
struct OnboardingRouter: RouterProtocol {
    typealias SheetRouteType = OnboardingSheetRoute

    let context: RouterContextLite
}
```

#### Switching from Lite to the tab bar

When the flow ends and the tab bar must appear, build an `AppCoordinator` **from** the lite one. It takes over the same sheet and alert coordinators, so pending sheets and alerts are preserved and `.stackableSheetsAndAlert` only needs to be attached once:

```swift
@State private var appCoordinatorLite = AppCoordinatorLite()
@State private var appCoordinator: AppCoordinator?

var body: some Scene {
    WindowGroup {
        Group {
            if let appCoordinator {
                MainTabView(appCoordinator: appCoordinator)
            } else {
                onboardingView
            }
        }
        // Attached once: the tab-enabled coordinator reuses the lite one's coordinators.
        .stackableSheetsAndAlert(sheetCoordinator: appCoordinatorLite.sheetCoordinator,
                                 alertCoordinator: appCoordinatorLite.alertCoordinator)
    }
}

private func finishOnboarding() {
    withAnimation {
        appCoordinator = AppCoordinator(from: appCoordinatorLite,
                                        selectedTab: TabItem.home,
                                        possibleTabs: TabItem.allCases)
    }
}
```

## Architecture Overview

```
AppCoordinator (app-level, with tabs)          AppCoordinatorLite (app-level, no tabs)
├── SheetCoordinator  — stackable sheets       ├── SheetCoordinator
├── AlertCoordinator  — alert queue (FIFO)     └── AlertCoordinator
└── TabCoordinator    — tab selection
        ↓ RouterGlobalContext                          ↓ RouterGlobalContextLite

NavigationContainerView (one per tab / sheet / column)
└── NavigationCoordinator — push/pop navigation stack
        ↓ RouterContext / RouterContextLite (global + navigation [+ split])

SplitContainerView (sidebar + [content +] detail)
└── SplitCoordinator      — selected content and detail routes
        ↓ RouterContext / RouterContextLite (global + navigation + split)
```

- **`RouterGlobalContext`** / **`RouterGlobalContextLite`** = sheet + alert (+ tab) coordinators, shared across all navigation stacks
- **`RouterContext`** / **`RouterContextLite`** = global context + `NavigationCoordinator` + optional `SplitCoordinator`, scoped to a single navigation (and, optionally, split) stack. You create it in the `NavigationContainerView` closure
- **Sheets stack** on top of each other (managed once at the root level, not per-screen)
- **Type erasure is internal** — you work with typed routes, never with `Any*Route`
- **`EmptyRoute`** is a no-op route conforming to `SheetRoute`, `NavigationRoute`, and `SplitRoute` at once — used as the default associated type in `RouterProtocol` so a router only declares the route types it actually needs

## Route Payloads & Hashable

Navigation routes must be `Hashable` (required by `NavigationPath`). Best practices:

- **Prefer identifiers** — pass `itemId: String` or `userId: UUID`, not full model objects. The destination view resolves data from a store/service.
- **If a non-Hashable payload is unavoidable**, implement `Hashable` based on a stable identity (e.g., the object's `id`).
- **Sheets are not affected** — `SheetCoordinator` uses identity-based hashing internally.

## Deeplinks & Universal Links

Conform to `ExternalLinkRoute` and implement `resolve(url:context:)`. Matched routes are presented as sheets automatically. The `context` is a `RouterContext` by default; set `typealias ContextType = RouterContextLite` for an app without tab bar.

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

Use `RouterContext.mockValue` (or `RouterContextLite.mockValue`) for SwiftUI previews:

```swift
#Preview {
    HomeBuilder.createView(with: HomePayload(context: RouterContext.mockValue))
}
```

## License

MIT

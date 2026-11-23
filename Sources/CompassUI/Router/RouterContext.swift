//
//  RouterContext.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

// MARK: - Protocols

/// App-level coordinators shared across all navigation stacks, without any tab-bar knowledge.
/// Adopted by ``RouterGlobalContext`` (with tabs) and ``RouterGlobalContextLite`` (without tabs).
public protocol RouterGlobalContextProtocol: Hashable {
    var sheetCoordinator: SheetCoordinator { get }
    var alertCoordinator: AlertCoordinator { get }
}

/// Navigation context provided to scenes, combining a local ``NavigationCoordinator`` with the
/// app-level coordinators. Adopted by ``RouterContext`` (with tabs) and ``RouterContextLite`` (without tabs).
public protocol RouterContextProtocol: Hashable {
    /// The app-level context this context is built from.
    associatedtype GlobalContext: RouterGlobalContextProtocol

    var navigationCoordinator: NavigationCoordinator { get }
    /// The split coordinator for the enclosing `NavigationSplitView`, or `nil` when this context
    /// isn't scoped to one (i.e., not provided by ``SplitContainerView``).
    var splitCoordinator: SplitCoordinator? { get }
    var sheetCoordinator: SheetCoordinator { get }
    var alertCoordinator: AlertCoordinator { get }
    /// The app-level coordinators extracted from this context.
    var globalContext: GlobalContext { get }

    init(navigationCoordinator: NavigationCoordinator,
         splitCoordinator: SplitCoordinator?,
         globalContext: GlobalContext)
}

// MARK: - With tab bar

/// Full navigation context combining a local ``NavigationCoordinator`` with app-level coordinators,
/// including the ``TabCoordinator``. Provided by ``NavigationContainerView`` through its content closure.
/// For apps (or flows) without a tab bar, use ``RouterContextLite``.
public struct RouterContext: @MainActor RouterContextProtocol {
    public let navigationCoordinator: NavigationCoordinator
    public let splitCoordinator: SplitCoordinator?
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator
    public let tabCoordinator: TabCoordinator

    /// The app-level coordinators (sheet, alert, tab) extracted from this context.
    public var globalContext: RouterGlobalContext {
        RouterGlobalContext(sheetCoordinator: sheetCoordinator,
                            alertCoordinator: alertCoordinator,
                            tabCoordinator: tabCoordinator)
    }

    public init(navigationCoordinator: NavigationCoordinator,
                splitCoordinator: SplitCoordinator? = nil,
                globalContext: RouterGlobalContext) {
        self.navigationCoordinator = navigationCoordinator
        self.splitCoordinator = splitCoordinator
        self.sheetCoordinator = globalContext.sheetCoordinator
        self.alertCoordinator = globalContext.alertCoordinator
        self.tabCoordinator = globalContext.tabCoordinator
    }

    /// A ready-made context for use in SwiftUI previews.
    public static var mockValue: RouterContext {
        RouterContext(
            navigationCoordinator: NavigationCoordinator(),
            globalContext: RouterGlobalContext.mockValue
        )
    }
}

/// App-level coordinators (sheet, alert, tab) shared across all navigation stacks.
/// Typically obtained from ``AppCoordinator/globalContext`` and passed to
/// ``NavigationContainerView`` and `.externalLinks`.
public struct RouterGlobalContext: @MainActor RouterGlobalContextProtocol {
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator
    public let tabCoordinator: TabCoordinator

    public init(sheetCoordinator: SheetCoordinator,
                alertCoordinator: AlertCoordinator,
                tabCoordinator: TabCoordinator) {
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
        self.tabCoordinator = tabCoordinator
    }

    /// A ready-made global context for use in SwiftUI previews.
    public static var mockValue: RouterGlobalContext {
        enum MockTable: @MainActor TabRoute, CaseIterable {
            case tab
        }
        return RouterGlobalContext(
            sheetCoordinator: SheetCoordinator(),
            alertCoordinator: AlertCoordinator(),
            tabCoordinator: TabCoordinator(selectedTab: MockTable.tab.erased(),
                                           possibleTabs: MockTable.allCases.map({ $0.erased() }))
        )
    }
}

// MARK: - Without tab bar

/// Navigation context for apps or flows without a tab bar (e.g., onboarding, login).
/// Same as ``RouterContext`` minus the ``TabCoordinator``: routers using it can't call `selectTab`.
public struct RouterContextLite: @MainActor RouterContextProtocol {
    public let navigationCoordinator: NavigationCoordinator
    public let splitCoordinator: SplitCoordinator?
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator

    /// The app-level coordinators (sheet, alert) extracted from this context.
    public var globalContext: RouterGlobalContextLite {
        RouterGlobalContextLite(sheetCoordinator: sheetCoordinator,
                                alertCoordinator: alertCoordinator)
    }

    public init(navigationCoordinator: NavigationCoordinator,
                splitCoordinator: SplitCoordinator? = nil,
                globalContext: RouterGlobalContextLite) {
        self.navigationCoordinator = navigationCoordinator
        self.splitCoordinator = splitCoordinator
        self.sheetCoordinator = globalContext.sheetCoordinator
        self.alertCoordinator = globalContext.alertCoordinator
    }

    /// A ready-made context for use in SwiftUI previews.
    public static var mockValue: RouterContextLite {
        RouterContextLite(
            navigationCoordinator: NavigationCoordinator(),
            globalContext: RouterGlobalContextLite.mockValue
        )
    }
}

/// App-level coordinators (sheet, alert) shared across all navigation stacks of an app without tab bar.
/// Typically obtained from ``AppCoordinatorLite/globalContext`` and passed to
/// ``NavigationContainerView`` and `.externalLinks`.
public struct RouterGlobalContextLite: @MainActor RouterGlobalContextProtocol {
    public let sheetCoordinator: SheetCoordinator
    public let alertCoordinator: AlertCoordinator

    public init(sheetCoordinator: SheetCoordinator,
                alertCoordinator: AlertCoordinator) {
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
    }

    /// A ready-made global context for use in SwiftUI previews.
    public static var mockValue: RouterGlobalContextLite {
        RouterGlobalContextLite(sheetCoordinator: SheetCoordinator(),
                                alertCoordinator: AlertCoordinator())
    }
}

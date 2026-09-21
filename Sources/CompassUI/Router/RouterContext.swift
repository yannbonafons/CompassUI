//
//  RouterContext.swift
//  CompassUI
//
//  Created by Yann Bonafons on 27/03/2026.
//

/// Full navigation context combining a local ``NavigationCoordinator`` with app-level coordinators.
/// Provided by ``NavigationContainerView`` through its content closure.
public struct RouterContext: Hashable {
    public let navigationCoordinator: NavigationCoordinator
    /// The split coordinator for the enclosing `NavigationSplitView`, or `nil` when this context
    /// isn't scoped to one (i.e., not provided by ``SplitContainerView``).
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
        enum MockTable: @MainActor TabRoute, CaseIterable {
            case tab
        }
        return RouterContext(
            navigationCoordinator: NavigationCoordinator(),
            globalContext: RouterGlobalContext.mockValue
        )
    }
}

/// App-level coordinators (sheet, alert, tab) shared across all navigation stacks.
/// Typically obtained from ``AppCoordinator/globalContext`` and passed to
/// ``NavigationContainerView`` and `.externalLinks`.
public struct RouterGlobalContext: Hashable {
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

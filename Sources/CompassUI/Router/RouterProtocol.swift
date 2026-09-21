//
//  RouterProtocol.swift
//  CompassUI
//
//  Created by Yann Bonafons on 24/03/2026.
//

/// Optional convenience layer over coordinators. Create one per scene/feature to get
/// type-safe `push`, `pop`, `showSheet`, `selectTab`, `showAlert`, `showDetail` methods
/// scoped to that scene's route types.
///
/// Associated types default to ``EmptyRoute`` so a conforming type only needs to specify
/// the route types it actually uses (navigation, sheet, and/or split).
///
/// You can always use coordinators directly via ``RouterContext`` instead.
public protocol RouterProtocol: Hashable {
    /// The route type pushed via ``push(_:animated:)``. Defaults to ``EmptyRoute`` when unused.
    associatedtype NavigationRouteType: NavigationRoute
    /// The route type presented via ``showSheet(_:animated:)``. Defaults to ``EmptyRoute`` when unused.
    associatedtype SheetRouteType: SheetRoute
    /// The route type presented via ``showDetail(_:animated:)``. Defaults to ``EmptyRoute`` when unused.
    associatedtype SplitRouteType: SplitRoute

    var context: RouterContext { get }
}

extension RouterProtocol {
    typealias NavigationRouteType = EmptyRoute
    typealias SheetRouteType = EmptyRoute
    typealias SplitRouteType = EmptyRoute

    /// Pushes `route` onto the enclosing `NavigationStack`.
    public func push(_ route: NavigationRouteType, animated: Bool = true) {
        context.navigationCoordinator.push(route, animated: animated)
    }

    /// Pops the top-most route off the enclosing `NavigationStack`.
    public func pop(animated: Bool = true) {
        context.navigationCoordinator.pop(animated: animated)
    }

    /// Pops back to the root of the enclosing `NavigationStack`.
    public func popToRoot(animated: Bool = true) {
        context.navigationCoordinator.popToRoot(animated: animated)
    }

    /// Presents `route` as a sheet, stacked on top of any sheet already presented.
    public func showSheet(_ route: SheetRouteType, animated: Bool = true) {
        context.sheetCoordinator.showSheet(route, animated: animated)
    }

    /// Dismisses the top-most sheet.
    public func hideSheet(animated: Bool = true) {
        context.sheetCoordinator.hideSheet(animated: animated)
    }

    /// Dismisses a specific sheet by identity, regardless of its position in the stack.
    public func hideSheet(_ route: SheetRouteType, animated: Bool = true) {
        context.sheetCoordinator.hideSheet(route, animated: animated)
    }

    /// Dismisses every currently presented sheet.
    public func hideAll(animated: Bool = true) {
        context.sheetCoordinator.hideAll()
    }

    /// Selects `route` as the active tab, if it is one of the possible tabs.
    public func selectTab<TabRouteType: TabRoute>(_ route: TabRouteType) {
        context.tabCoordinator.selectecTab(route)
    }

    /// Queues `alertConfiguration` for presentation.
    public func showAlert(_ alertConfiguration: AlertConfiguration) {
        context.alertCoordinator.showAlert(alertConfiguration)
    }

    /// Displays `route` in the detail column of the enclosing `NavigationSplitView`.
    /// No-ops if this context isn't scoped to a ``SplitCoordinator`` (i.e., not provided by ``SplitContainerView``).
    public func showDetail(_ route: SplitRouteType, animated: Bool = false) {
        context.splitCoordinator?.show(route, animated: animated)
    }

    /// Clears the detail column of the enclosing `NavigationSplitView`.
    public func dismissDetail(animated: Bool = false) {
        context.splitCoordinator?.dismissDetail(animated: animated)
    }
}

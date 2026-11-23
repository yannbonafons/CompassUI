//
//  RouterProtocol.swift
//  CompassUI
//
//  Created by Yann Bonafons on 24/03/2026.
//

/// Optional convenience layer over coordinators. Create one per scene/feature to get
/// type-safe `push`, `pop`, `showSheet`, `showAlert` methods
/// scoped to that scene's route types.
///
/// Works with any ``RouterContextProtocol``: ``RouterContext`` (with tab bar) or
/// ``RouterContextLite`` (without tab bar). Tab selection is only available through
/// ``TabRouterProtocol``, split columns through ``SplitRouterProtocol``.
///
/// Associated types default to ``EmptyRoute`` so a conforming type only needs to specify
/// the route types it actually uses (navigation, sheet).
///
/// You can always use coordinators directly via the context instead.
public protocol RouterProtocol {
    /// The context type this router reads its coordinators from.
    associatedtype Context: RouterContextProtocol
    /// The route type pushed via ``push(_:animated:)``. Defaults to ``EmptyRoute`` when unused.
    associatedtype NavigationRouteType: NavigationRoute = EmptyRoute
    /// The route type presented via ``showSheet(_:animated:)``. Defaults to ``EmptyRoute`` when unused.
    associatedtype SheetRouteType: SheetRoute = EmptyRoute

    var context: Context { get }
}

extension RouterProtocol {
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

    /// Queues `alertConfiguration` for presentation.
    public func showAlert(_ alertConfiguration: AlertConfiguration) {
        context.alertCoordinator.showAlert(alertConfiguration)
    }
}

/// ``RouterProtocol`` for scenes living in an app with a tab bar. Adds `selectTab`, which requires
/// the full ``RouterContext`` (the lite context has no ``TabCoordinator``).
public protocol TabRouterProtocol: RouterProtocol where Context == RouterContext {}

extension TabRouterProtocol {
    /// Selects `route` as the active tab, if it is one of the possible tabs.
    public func selectTab<TabRouteType: TabRoute>(_ route: TabRouteType) {
        context.tabCoordinator.selectecTab(route)
    }
}

/// ``RouterProtocol`` for scenes inside a ``SplitContainerView``. Adds `showContent`, `dismissContent`,
/// `showDetail` and `dismissDetail`, typed with the scene's split route type.
public protocol SplitRouterProtocol: RouterProtocol {
    /// The route type presented via ``showContent(_:animated:)`` and ``showDetail(_:animated:)``.
    /// Defaults to ``EmptyRoute`` when unused.
    associatedtype SplitRouteType: SplitRoute = EmptyRoute
}

extension SplitRouterProtocol {
    /// Displays `route` in the content column of the enclosing `NavigationSplitView`.
    /// No-ops if this context isn't scoped to a ``SplitCoordinator`` (i.e., not provided by ``SplitContainerView``).
    public func showContent(_ route: SplitRouteType, animated: Bool = false) {
        context.splitCoordinator?.showContent(route, animated: animated)
    }

    /// Clears the content column (and the detail column, which depends on it) of the enclosing `NavigationSplitView`.
    public func dismissContent(animated: Bool = false) {
        context.splitCoordinator?.dismissContent(animated: animated)
    }

    /// Displays `route` in the detail column of the enclosing `NavigationSplitView`.
    /// No-ops if this context isn't scoped to a ``SplitCoordinator`` (i.e., not provided by ``SplitContainerView``).
    public func showDetail(_ route: SplitRouteType, animated: Bool = false) {
        context.splitCoordinator?.showDetail(route, animated: animated)
    }

    /// Clears the detail column of the enclosing `NavigationSplitView`.
    public func dismissDetail(animated: Bool = false) {
        context.splitCoordinator?.dismissDetail(animated: animated)
    }
}

//
//  RouterProtocol.swift
//  CompassUI
//
//  Created by Yann Bonafons on 24/03/2026.
//

/// Optional convenience layer over coordinators. Create one per scene/feature to get
/// type-safe `push`, `pop`, `showSheet`, `selectTab`, `showAlert` methods
/// scoped to that scene's route types.
///
/// You can always use coordinators directly via ``RouterContext`` instead.
public protocol RouterProtocol: Hashable {
    associatedtype NavigationRouteType: NavigationRoute
    associatedtype SheetRouteType: SheetRoute

    var context: RouterContext { get }
}

extension RouterProtocol {
    public func push(_ route: NavigationRouteType, animated: Bool = true) {
        context.navigationCoordinator.push(route, animated: animated)
    }

    public func pop(animated: Bool = true) {
        context.navigationCoordinator.pop(animated: animated)
    }

    public func popToRoot(animated: Bool = true) {
        context.navigationCoordinator.popToRoot(animated: animated)
    }

    public func showSheet(_ route: SheetRouteType, animated: Bool = true) {
        context.sheetCoordinator.showSheet(route, animated: animated)
    }

    public func hideSheet(animated: Bool = true) {
        context.sheetCoordinator.hideSheet(animated: animated)
    }

    public func hideSheet(_ route: SheetRouteType, animated: Bool = true) {
        context.sheetCoordinator.hideSheet(route, animated: animated)
    }

    public func hideAll(animated: Bool = true) {
        context.sheetCoordinator.hideAll()
    }

    public func selectTab<TabRouteType: TabRoute>(_ route: TabRouteType) {
        context.tabCoordinator.selectecTab(route)
    }

    public func showAlert(_ alertConfiguration: AlertConfiguration) {
        context.alertCoordinator.showAlert(alertConfiguration)
    }
}

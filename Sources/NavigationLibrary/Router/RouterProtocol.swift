//
//  RouterProtocol.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 24/03/2026.
//

public protocol RouterProtocol: Hashable {
    var context: RouterContext { get }
}

extension RouterProtocol {
    public func push<RouteType: NavigationRoute>(_ route: RouteType, animated: Bool = true) {
        context.navigationCoordinator.push(route, animated: animated)
    }

    public func pop(animated: Bool = true) {
        context.navigationCoordinator.pop(animated: animated)
    }

    public func popToRoot(animated: Bool = true) {
        context.navigationCoordinator.popToRoot(animated: animated)
    }

    public func showSheet<SheetRouteType: SheetRoute>(_ route: SheetRouteType, animated: Bool = true) {
        context.sheetCoordinator.showSheet(route, animated: animated)
    }

    public func hideSheet(animated: Bool = true) {
        context.sheetCoordinator.hideSheet(animated: animated)
    }

    public func hideSheet<SheetRouteType: SheetRoute>(_ route: SheetRouteType, animated: Bool = true) {
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

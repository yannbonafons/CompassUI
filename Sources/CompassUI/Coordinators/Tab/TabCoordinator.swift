//
//  TabCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

/// Manages the currently selected tab and validates selection against the tabs
/// declared available for the app.
@Observable
public class TabCoordinator: @MainActor HashableProtocol {
    /// The currently selected tab.
    public var selectedTab: AnyTabRoute
    private var possibleTabs: [AnyTabRoute]

    public init(selectedTab: AnyTabRoute,
                possibleTabs: [AnyTabRoute]) {
        self.selectedTab = selectedTab
        self.possibleTabs = possibleTabs
    }

    /// Selects `route` as the active tab. No-ops if `route` isn't one of the possible tabs.
    public func selectecTab<TabRouteType: TabRoute>(_ route: TabRouteType) {
        let erasedRoute = route.erased()
        guard possibleTabs.contains(erasedRoute) else {
            return
        }
        selectedTab = erasedRoute
    }

    /// Returns whether `route` is one of the tabs declared available for the app.
    public func isTabAvailable<TabRouteType: TabRoute>(_ route: TabRouteType) -> Bool {
        let erasedRoute = route.erased()
        return possibleTabs.contains(erasedRoute)
    }
}

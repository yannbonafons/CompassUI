//
//  TabCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

@Observable
public class TabCoordinator: @MainActor HashableProtocol {
    public var selectedTab: AnyTabRoute
    private var possibleTabs: [AnyTabRoute]

    public init(selectedTab: AnyTabRoute,
                possibleTabs: [AnyTabRoute]) {
        self.selectedTab = selectedTab
        self.possibleTabs = possibleTabs
    }

    public func selectecTab<TabRouteType: TabRoute>(_ route: TabRouteType) {
        let erasedRoute = route.erased()
        guard possibleTabs.contains(erasedRoute) else {
            return
        }
        selectedTab = erasedRoute
    }

    public func isTabAvailable<TabRouteType: TabRoute>(_ route: TabRouteType) -> Bool {
        let erasedRoute = route.erased()
        return possibleTabs.contains(erasedRoute)
    }
}

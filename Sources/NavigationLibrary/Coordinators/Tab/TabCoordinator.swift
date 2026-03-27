//
//  TabCoordinator.swift
//  NavigationLibrary
//
//  Created by Yann Bonafons on 26/03/2026.
//

import SwiftUI

@Observable
public class TabCoordinator: HashableProtocol {
    public var selectedTab: AnyTabRoute
    public private(set) var possibleTabs: [AnyTabRoute]

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
}

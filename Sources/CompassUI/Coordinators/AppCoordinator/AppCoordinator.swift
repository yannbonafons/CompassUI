//
//  AppCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

@Observable
public final class AppCoordinator {
    public var sheetCoordinator: SheetCoordinator
    public var alertCoordinator: AlertCoordinator
    public var tabCoordinator: TabCoordinator

    public init<TabRouteType: TabRoute>(sheetCoordinator: SheetCoordinator = SheetCoordinator(),
                                        alertCoordinator: AlertCoordinator = AlertCoordinator(),
                                        selectedTab: TabRouteType,
                                        possibleTabs: [TabRouteType]) {
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
        self.tabCoordinator = TabCoordinator(selectedTab: selectedTab.erased(),
                                             possibleTabs: possibleTabs.map({ $0.erased() }))
    }

    public var globalContext: RouterGlobalContext {
        RouterGlobalContext(sheetCoordinator: sheetCoordinator,
                            alertCoordinator: alertCoordinator,
                            tabCoordinator: tabCoordinator)
    }
}

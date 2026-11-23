//
//  AppCoordinator.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI

/// Top-level coordinator grouping sheet, alert, and tab coordinators.
/// Use ``globalContext`` to pass all three at once to ``NavigationContainerView``
/// and `.externalLinks`.
@Observable
public final class AppCoordinator {
    /// Manages the app-wide stack of presented sheets.
    public var sheetCoordinator: SheetCoordinator
    /// Manages the app-wide alert queue.
    public var alertCoordinator: AlertCoordinator
    /// Manages the app-wide tab selection.
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

    /// Creates a tab-enabled coordinator that takes over the sheet and alert coordinators of an
    /// ``AppCoordinatorLite`` (e.g., when an onboarding flow ends and the tab bar appears).
    public convenience init<TabRouteType: TabRoute>(from lite: AppCoordinatorLite,
                                                    selectedTab: TabRouteType,
                                                    possibleTabs: [TabRouteType]) {
        self.init(sheetCoordinator: lite.sheetCoordinator,
                  alertCoordinator: lite.alertCoordinator,
                  selectedTab: selectedTab,
                  possibleTabs: possibleTabs)
    }

    /// The app-level coordinators (sheet, alert, tab) grouped for consumers that need all three.
    public var globalContext: RouterGlobalContext {
        RouterGlobalContext(sheetCoordinator: sheetCoordinator,
                            alertCoordinator: alertCoordinator,
                            tabCoordinator: tabCoordinator)
    }
}

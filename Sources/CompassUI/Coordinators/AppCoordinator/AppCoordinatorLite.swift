//
//  AppCoordinatorLite.swift
//  CompassUI
//
//  Created by Yann Bonafons on 23/11/2026.
//

import SwiftUI

/// Top-level coordinator for apps (or flows, e.g. onboarding) without a tab bar, grouping sheet and
/// alert coordinators. Use ``globalContext`` to pass both at once to ``NavigationContainerView``
/// and `.externalLinks`. Once a tab bar is needed, build an ``AppCoordinator`` with
/// ``AppCoordinator/init(from:selectedTab:possibleTabs:)`` to keep the same sheet and alert state.
@Observable
public final class AppCoordinatorLite {
    /// Manages the app-wide stack of presented sheets.
    public var sheetCoordinator: SheetCoordinator
    /// Manages the app-wide alert queue.
    public var alertCoordinator: AlertCoordinator

    public init(sheetCoordinator: SheetCoordinator = SheetCoordinator(),
                alertCoordinator: AlertCoordinator = AlertCoordinator()) {
        self.sheetCoordinator = sheetCoordinator
        self.alertCoordinator = alertCoordinator
    }

    /// The app-level coordinators (sheet, alert) grouped for consumers that need both.
    public var globalContext: RouterGlobalContextLite {
        RouterGlobalContextLite(sheetCoordinator: sheetCoordinator,
                                alertCoordinator: alertCoordinator)
    }
}

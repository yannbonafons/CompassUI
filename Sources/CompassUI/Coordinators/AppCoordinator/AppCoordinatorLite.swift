//
//  AppCoordinatorLite.swift
//  CompassUI
//
//  Created by Yann Bonafons on 23/11/2026.
//

import SwiftUI

/// Top-level coordinator grouping sheet, alert, and tab coordinators.
/// Use ``globalContext`` to pass all three at once to ``NavigationContainerView``
/// and `.externalLinks`.
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

    /// The app-level coordinators (sheet, alert, tab) grouped for consumers that need all three.
    public var globalContext: RouterGlobalContextLite {
        RouterGlobalContextLite(sheetCoordinator: sheetCoordinator,
                                alertCoordinator: alertCoordinator)
    }
}

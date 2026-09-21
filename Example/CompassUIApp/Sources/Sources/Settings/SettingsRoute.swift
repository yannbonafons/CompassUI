//
//  SettingsRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI
import CompassUI

enum SettingsRoute: @MainActor NavigationRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let infoPayload):
            InfoBuilder.createView(with: infoPayload)
        }
    }
}

enum SettingsSheetRoute: @MainActor SheetRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let payload):
            NavigationContainerView { navigationCoordinator in
                InfoBuilder.createView(with: InfoPayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                                globalContext: payload.context.globalContext)))
                .asModal(coordinator: payload.context.sheetCoordinator)
            }
        }
    }
}

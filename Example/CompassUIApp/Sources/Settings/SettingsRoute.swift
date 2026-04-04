//
//  SettingsRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 16/03/2026.
//

import SwiftUI
import CompassUI

enum SettingsRoute: NavigationRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let infoPayload):
            InfoBuilder.createView(with: infoPayload)
        }
    }
}

enum SettingsSheetRoute: SheetRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let payload):
            NavigationContainerView(globalContext: payload.context.globalContext) { context in
                InfoBuilder.createView(with: InfoPayload(context: context))
                    .asModal(coordinator: context.sheetCoordinator)
            }
        }
    }
}

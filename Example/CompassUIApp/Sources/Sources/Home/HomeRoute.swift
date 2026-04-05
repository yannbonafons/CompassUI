//
//  HomeRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import CompassUI

enum HomeRoute: @MainActor NavigationRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let infoPayload):
            InfoBuilder.createView(with: infoPayload)
        }
    }
}

enum HomeSheetRoute: @MainActor SheetRoute {
    case home(homePayload: HomePayload)
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .home(let payload):
            NavigationContainerView(globalContext: payload.context.globalContext) { context in
                HomeBuilder.createView(with: HomePayload(context: context))
                    .asModal(coordinator: context.sheetCoordinator)
            }
        case .info(let payload):
            NavigationContainerView(globalContext: payload.context.globalContext) { context in
                InfoBuilder.createView(with: InfoPayload(context: context))
                    .asModal(coordinator: context.sheetCoordinator)
            }
        }
    }
}

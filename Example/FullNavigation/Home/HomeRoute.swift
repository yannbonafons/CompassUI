//
//  HomeRoute.swift
//  FullNavigation
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import NavigationLibrary

enum HomeRoute: NavigationRoute {
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .info(let infoPayload):
            InfoBuilder.createView(with: infoPayload)
        }
    }
}

enum HomeSheetRoute: SheetRoute {
    case home(homePayload: HomePayload)
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .home(let payload):
            NavigationContainerView(sheetCoordinator: payload.context.sheetCoordinator,
                                    alertCoordinator: payload.context.alertCoordinator,
                                    tabCoordinator: payload.context.tabCoordinator) { context in
                HomeBuilder.createView(with: HomePayload(context: context))
                    .asModal(coordinator: context.sheetCoordinator)
            }
        case .info(let payload):
            NavigationContainerView(sheetCoordinator: payload.context.sheetCoordinator,
                                    alertCoordinator: payload.context.alertCoordinator,
                                    tabCoordinator: payload.context.tabCoordinator) { context in
                InfoBuilder.createView(with: InfoPayload(context: context))
                    .asModal(coordinator: context.sheetCoordinator)
            }
        }
    }
}

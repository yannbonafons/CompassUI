//
//  InfoRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 24/03/2026.
//

import SwiftUI
import CompassUI

enum InfoSheetRoute: SheetRoute {
    case home(homePayload: HomePayload)

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
        }
    }
}

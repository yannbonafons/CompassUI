//
//  InfoRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 24/03/2026.
//

import SwiftUI
import CompassUI

enum InfoSheetRoute: @MainActor SheetRoute {
    case home(homePayload: HomePayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .home(let payload):
            NavigationContainerView(globalContext: payload.context.globalContext) { context in
                HomeBuilder.createView(with: HomePayload(context: context))
                    .asModal(coordinator: context.sheetCoordinator)
            }
        }
    }
}

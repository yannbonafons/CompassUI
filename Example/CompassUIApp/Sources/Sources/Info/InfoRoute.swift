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
            NavigationContainerView { navigationCoordinator in
                HomeBuilder.createView(with: HomePayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                                globalContext: payload.context.globalContext)))
            }
        }
    }
}

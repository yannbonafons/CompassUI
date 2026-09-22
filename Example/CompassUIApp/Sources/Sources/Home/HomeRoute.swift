//
//  HomeRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import CompassUI

enum HomeSplitRoute: @MainActor SplitRoute {
    case home(homePayload: HomePayload)
    case info(infoPayload: InfoPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .home(let payload):
            NavigationContainerView { navigationCoordinator in
                HomeBuilder.createView(with: HomePayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                                globalContext: payload.context.globalContext)))
            }
        case .info(let payload):
            NavigationContainerView { navigationCoordinator in
                InfoBuilder.createView(with: InfoPayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                                globalContext: payload.context.globalContext)))
            }
        }
    }
}

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
            NavigationContainerView { navigationCoordinator in
                HomeBuilder.createView(with: HomePayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                                globalContext: payload.context.globalContext)))
            }
        case .info(let payload):
            NavigationContainerView { navigationCoordinator in
                InfoBuilder.createView(with: InfoPayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                                globalContext: payload.context.globalContext)))
            }
        }
    }
}

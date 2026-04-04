//
//  AppExternalLinkRoute.swift
//  ExampleNavigationApp
//
//  Created by Yann Bonafons on 29/03/2026.
//

import SwiftUI
import CompassUI

enum AppExternalLinkRoute: ExternalLinkRoute {
    case info(infoPayload: InfoPayload)

    static func resolve(url: URL, context: RouterContext) -> Self? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        switch components.path {
        case "/info":
            return .info(infoPayload: InfoPayload(context: context))
        default:
            return nil
        }
    }

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

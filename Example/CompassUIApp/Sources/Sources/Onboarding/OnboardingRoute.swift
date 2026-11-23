//
//  OnboardingRoute.swift
//  CompassUI
//
//  Created by Yann Bonafons on 23/11/2026.
//

import SwiftUI
import CompassUI

enum OnboardingSheetRoute: @MainActor SheetRoute {
    case login(loginPayload: LoginPayload)

    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .login(let payload):
            NavigationContainerView { navigationCoordinator in
                LoginBuilder.createView(with: LoginPayload(context: RouterContextLite(navigationCoordinator: navigationCoordinator,
                                                                                      globalContext: payload.context.globalContext),
                                                           onLoggedIn: payload.onLoggedIn))
            }
        }
    }
}

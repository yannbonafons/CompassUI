//
//  OnboardingScene.swift
//  CompassUI
//
//  Created by Yann Bonafons on 23/11/2026.
//

import SwiftUI
import CompassUI

protocol OnboardingRouterProtocol {
    func showLogin(onLoggedIn: @escaping @MainActor () -> Void)
}

/// Uses `RouterContextLite`: no tab bar exists yet while onboarding is displayed.
struct OnboardingRouter: OnboardingRouterProtocol, @MainActor RouterProtocol {
    typealias SheetRouteType = OnboardingSheetRoute

    let context: RouterContextLite

    func showLogin(onLoggedIn: @escaping @MainActor () -> Void) {
        showSheet(.login(loginPayload: LoginPayload(context: context, onLoggedIn: onLoggedIn)))
    }
}

struct OnboardingPayload: @MainActor PayloadProtocol {
    typealias BuilderType = OnboardingBuilder

    let context: RouterContextLite
    /// Called once the user is logged in, to leave the onboarding. Ignored by `Hashable`.
    let onCompleted: @MainActor () -> Void

    static func == (lhs: OnboardingPayload, rhs: OnboardingPayload) -> Bool {
        lhs.context == rhs.context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(context)
    }
}

struct OnboardingBuilder: @MainActor BuilderProtocol {
    static func createView(with payload: OnboardingPayload) -> some View {
        let router = OnboardingRouter(context: payload.context)
        let sceneModel = OnboardingSceneModel(router: router,
                                              onCompleted: payload.onCompleted)
        return OnboardingScene(onboardingSceneModel: sceneModel)
    }
}

@Observable
class OnboardingSceneModel {
    private let router: OnboardingRouterProtocol
    private let onCompleted: @MainActor () -> Void

    init(router: OnboardingRouterProtocol,
         onCompleted: @escaping @MainActor () -> Void) {
        self.router = router
        self.onCompleted = onCompleted
    }

    func login() {
        router.showLogin(onLoggedIn: onCompleted)
    }
}

struct OnboardingScene: View {
    @State var onboardingSceneModel: OnboardingSceneModel

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.wave")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome")
                .font(.largeTitle)
            Button("Log in") {
                onboardingSceneModel.login()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    OnboardingBuilder.createView(with: OnboardingPayload(context: RouterContextLite.mockValue,
                                                         onCompleted: {}))
}

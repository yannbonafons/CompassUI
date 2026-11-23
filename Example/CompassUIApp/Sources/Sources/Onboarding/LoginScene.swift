//
//  LoginScene.swift
//  CompassUI
//
//  Created by Yann Bonafons on 23/11/2026.
//

import SwiftUI
import CompassUI

protocol LoginRouterProtocol {
    func close()
}

struct LoginRouter: LoginRouterProtocol, @MainActor RouterProtocol {
    typealias SheetRouteType = OnboardingSheetRoute

    let context: RouterContextLite

    func close() {
        hideSheet()
    }
}

struct LoginPayload: @MainActor PayloadProtocol {
    typealias BuilderType = LoginBuilder

    let context: RouterContextLite
    /// Called after the login sheet is dismissed. Ignored by `Hashable`.
    let onLoggedIn: @MainActor () -> Void

    static func == (lhs: LoginPayload, rhs: LoginPayload) -> Bool {
        lhs.context == rhs.context
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(context)
    }
}

struct LoginBuilder: @MainActor BuilderProtocol {
    static func createView(with payload: LoginPayload) -> some View {
        let router = LoginRouter(context: payload.context)
        let sceneModel = LoginSceneModel(router: router,
                                         onLoggedIn: payload.onLoggedIn)
        return LoginScene(loginSceneModel: sceneModel)
    }
}

@Observable
class LoginSceneModel {
    private let router: LoginRouterProtocol
    private let onLoggedIn: @MainActor () -> Void

    init(router: LoginRouterProtocol,
         onLoggedIn: @escaping @MainActor () -> Void) {
        self.router = router
        self.onLoggedIn = onLoggedIn
    }

    func validate() {
        router.close()
        onLoggedIn()
    }
}

struct LoginScene: View {
    @State var loginSceneModel: LoginSceneModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Login")
                .font(.title)
            Button("Validate") {
                loginSceneModel.validate()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    LoginBuilder.createView(with: LoginPayload(context: RouterContextLite.mockValue,
                                               onLoggedIn: {}))
}

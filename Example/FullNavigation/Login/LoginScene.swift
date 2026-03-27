//
//  LoginPayload.swift
//  FullNavigation
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI

struct LoginPayload: PayloadProtocol {
    typealias BuilderType = LoginBuilder
    
//    let router: NavigationRouter<LoginRoute, LoginSheetRoute>()

}
struct LoginBuilder: BuilderProtocol {
    static func createView(with payload: LoginPayload) -> some View {
        EmptyView()
    }
}

struct LoginScene: View {
    @State private var loginSceneModel: LoginSceneModel
    
    var body: some View {
        Text("Login Scene")
    }
}

@Observable
final class LoginSceneModel {
    
}

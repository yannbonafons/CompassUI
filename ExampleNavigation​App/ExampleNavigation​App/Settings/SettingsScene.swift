//
//  SettingsPayload.swift
//  FullNavigation
//
//  Created by Yann Bonafons on 17/03/2026.
//

import SwiftUI
import NavigationLibrary

protocol SettingsRouterProtocol {
    func showInfo()
    func goToHomeTab()
    func showAlert()
    func showDoubleAlert()
}

struct SettingsRouter: SettingsRouterProtocol, RouterProtocol {
    typealias NavigationRouteType = EmptyNavigationRoute
    typealias SheetRouteType = SettingsSheetRoute

    let context: RouterContext

    func showInfo() {
        let infoPayload = InfoPayload(context:  context)
        showSheet(.info(infoPayload: infoPayload))
    }
    
    func goToHomeTab() {
        selectTab(TabItem.home)
    }
    
    func showDoubleAlert() {
        showAlert(AlertConfiguration(titleAndMessageType: .messageAndTitle(message: "Im the first alert",
                                                                           title: "ONE"),
                                     actions: [
                                        .cancel(),
                                        .ok()
                                     ]))
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            showAlert(AlertConfiguration(titleAndMessageType: .messageAndTitle(message: "Im the second alert",
                                                                               title: "TWO"),
                                         actions: [
                                            .cancel(),
                                            .ok()
                                         ]))

        }
    }
    
    func showAlert() {
        showAlert(AlertConfiguration(titleAndMessageType: .messageAndTitle(message: "Thats terrible!",
                                                                           title: "Warning"),
                                     actions: [
                                        .cancel(),
                                        .ok()
                                     ]))
    }
}

struct SettingsPayload: PayloadProtocol {
    typealias BuilderType = SettingsBuilder

    let context: RouterContext
}

struct SettingsBuilder: BuilderProtocol {
    static func createView(with payload: SettingsPayload) -> some View {
        let settingsRouter = SettingsRouter(context: payload.context)
        let settingsSceneModel = SettingsSceneModel(router: settingsRouter)
        return SettingsScene(settingsSceneModel: settingsSceneModel)
    }
}

@Observable
class SettingsSceneModel {
    var router: SettingsRouterProtocol

    init(router: SettingsRouterProtocol) {
        self.router = router
    }

    func showInfo() {
        router.showInfo()
    }
    
    func goToHomeTab() {
        router.goToHomeTab()
    }
}

struct SettingsScene: View {
    @State var settingsSceneModel: SettingsSceneModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Show Info") {
                settingsSceneModel.showInfo()
            }
            Button("Tab Home") {
                settingsSceneModel.goToHomeTab()
            }
            Button("Show Alert") {
                settingsSceneModel.router.showAlert()
            }
            Button("Show Double Alert") {
                settingsSceneModel.router.showDoubleAlert()
            }
        }
        .padding()
    }
}

#Preview {
    SettingsBuilder.createView(with: SettingsPayload(context: RouterContext.mockValue))
}

//
//  InfoPayload.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import CompassUI

protocol InfoRouterProtocol {
    func close()
    func showHome()
    func goToSettingsTab()
}

struct InfoRouter: InfoRouterProtocol, RouterProtocol {
    typealias NavigationRouteType = EmptyNavigationRoute
    typealias SheetRouteType = InfoSheetRoute

    let context: RouterContext

    func close() {
        hideSheet()
    }

    func showHome() {
        let homePayload = HomePayload(context: context)
        showSheet(.home(homePayload: homePayload))
    }
    
    func goToSettingsTab() {
        selectTab(TabItem.settings)
    }
}

struct InfoPayload: PayloadProtocol {
    typealias BuilderType = InfoBuilder

    let initialName = "Info"
    let context: RouterContext
}

struct InfoBuilder: BuilderProtocol {
    static func createView(with payload: InfoPayload) -> some View {
        let router = InfoRouter(context: payload.context)
        let infoSceneModel = InfoSceneModel(sceneName: payload.initialName,
                                            router: router)
        return InfoScene(infoSceneModel: infoSceneModel)
    }
}

struct InfoScene: View {
    @State var infoSceneModel: InfoSceneModel
    var body: some View {
        Text(infoSceneModel.sceneName)
        Button("Close") {
            infoSceneModel.close()
        }
        Button("Show Home") {
            infoSceneModel.showHome()
        }
        Button("Tab Settings") {
            infoSceneModel.router.goToSettingsTab()
        }
    }
}

@Observable
class InfoSceneModel {
    var sceneName: String
    let router: InfoRouterProtocol

    init(sceneName: String,
         router: InfoRouterProtocol) {
        self.sceneName = sceneName
        self.router = router
    }
    
    func close() {
        router.close()
    }
    
    func showHome() {
        router.showHome()
    }
}

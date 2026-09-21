//
//  ContentView.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import CompassUI

protocol HomeRouterProtocol {
    func showInfo(animated: Bool)
    func pushInfo(animated: Bool)
    func showInfoAsDetail()
    func showHomeAsDetail()
    func close()
    func showHome()
}

struct HomeRouter: HomeRouterProtocol, @MainActor RouterProtocol {
    typealias NavigationRouteType = HomeRoute
    typealias SheetRouteType = HomeSheetRoute
    typealias SplitRouteType = HomeSplitRoute

    let context: RouterContext

    func showInfo(animated: Bool) {
        let infoPayload = InfoPayload(context: context)
        showSheet(.info(infoPayload: infoPayload), animated: animated)
    }

    func showInfoAsDetail() {
        let infoPayload = InfoPayload(context: context)
        showDetail(.info(infoPayload: infoPayload))
    }

    func showHomeAsDetail() {
        let homePayload = HomePayload(context: context)
        showDetail(.home(homePayload: homePayload))
    }

    func pushInfo(animated: Bool) {
        let infoPayload = InfoPayload(context: context)
        push(.info(infoPayload: infoPayload), animated: animated)
    }

    func showHome() {
        let homePayload = HomePayload(context: context)
        showSheet(.home(homePayload: homePayload))
    }

    func close() {
        hideSheet()
    }
}

struct HomePayload: @MainActor PayloadProtocol {
    typealias BuilderType = HomeBuilder

    let context: RouterContext
}

struct HomeBuilder: @MainActor BuilderProtocol {
    static func createView(with payload: HomePayload) -> some View {
        let router = HomeRouter(context: payload.context)
        let homeSceneModel = HomeSceneModel(router: router)
        return HomeScene(homeSceneModel: homeSceneModel)
    }
}

@Observable
class HomeSceneModel {
    var router: HomeRouterProtocol

    init(router: HomeRouterProtocol) {
        self.router = router
    }
    
    func showInfoAsDetail() {
        router.showInfoAsDetail()
    }
    
    func showHomeAsDetail() {
        router.showHomeAsDetail()
    }

    
    func pushInfo() {
        router.pushInfo(animated: true)
    }
    
    func pushDirectInfo() {
        router.pushInfo(animated: false)
    }

    func showInfo() {
        router.showInfo(animated: true)
    }
    
    func showDirectInfo() {
        router.showInfo(animated: false)
    }
    
    func showHome() {
        router.showHome()
    }

    func close() {
        router.close()
    }
}

struct HomeScene: View {
    @State var homeSceneModel: HomeSceneModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Info detail") {
                homeSceneModel.showInfoAsDetail()
            }
            Button("Home detail") {
                homeSceneModel.showHomeAsDetail()
            }
            Button("Push Info") {
                homeSceneModel.pushInfo()
            }
            Button("Push Info") {
                homeSceneModel.pushInfo()
            }
            Button("Push direct Info") {
                homeSceneModel.pushDirectInfo()
            }
            Button("Show Info") {
                homeSceneModel.showInfo()
            }
            Button("Show direct Info") {
                homeSceneModel.showDirectInfo()
            }
            Button("Show Home") {
                homeSceneModel.showHome()
            }
            Button("Close sheet") {
                homeSceneModel.close()
            }
        }
        .padding()
    }
}

#Preview {
    HomeBuilder.createView(with: HomePayload(context: RouterContext.mockValue))
}


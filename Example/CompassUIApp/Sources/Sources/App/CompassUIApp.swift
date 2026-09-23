//
//  ExampleNavigationApp.swift
//  CompassUI
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import CompassUI

@main
struct ExampleNavigationApp: App {
    @State var appCoordinator = AppCoordinator(selectedTab: TabItem.home,
                                               possibleTabs: TabItem.allCases)
    
    var body: some Scene {
        WindowGroup {
            tabView
        }
    }
    
    var tabView: some View {
        TabView(selection: $appCoordinator.tabCoordinator.selectedTab) {
            if (appCoordinator.tabCoordinator.isTabAvailable(TabItem.home)) {
                Tab("Home", systemImage: "house", value: TabItem.home.erased()) {
                    SplitContainerView(HomeSplitRoute.self) { splitCoordinator in
                        NavigationContainerView { navigationCoordinator in
                            HomeBuilder.createView(
                                with: HomePayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                         splitCoordinator: splitCoordinator,
                                                                         globalContext: appCoordinator.globalContext))
                            )
                        }
                    }
                    .navigationSplitViewStyle(.balanced)
                }
            }
            if (appCoordinator.tabCoordinator.isTabAvailable(TabItem.settings)) {
                Tab("Settings", systemImage: "gear", value: TabItem.settings.erased()) {
                    NavigationContainerView { navigationCoordinator in
                        SettingsBuilder.createView(
                            with: SettingsPayload(context: RouterContext(navigationCoordinator: navigationCoordinator,
                                                                         globalContext: appCoordinator.globalContext))
                        )
                    }
                }
            }
        }
        .stackableSheets(coordinator: appCoordinator.sheetCoordinator)
        .alert(coordinator: appCoordinator.alertCoordinator)
        .externalLinks(AppExternalLinkRoute.self,
                       globalContext: appCoordinator.globalContext)
    }
}

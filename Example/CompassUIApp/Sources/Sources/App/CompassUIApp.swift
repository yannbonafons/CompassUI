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
            TabView(selection: $appCoordinator.tabCoordinator.selectedTab) {
                if (appCoordinator.tabCoordinator.isTabAvailable(TabItem.home)) {
                    Tab("Home", systemImage: "house", value: TabItem.home.erased()) {
                        NavigationContainerView(globalContext: appCoordinator.globalContext) { context in
                            HomeBuilder.createView(
                                with: HomePayload(context: context)
                            )
                        }
                    }
                }
                if (appCoordinator.tabCoordinator.isTabAvailable(TabItem.settings)) {
                    Tab("Settings", systemImage: "gear", value: TabItem.settings.erased()) {
                        NavigationContainerView(globalContext: appCoordinator.globalContext) { context in
                            SettingsBuilder.createView(
                                with: SettingsPayload(context: context)
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
}

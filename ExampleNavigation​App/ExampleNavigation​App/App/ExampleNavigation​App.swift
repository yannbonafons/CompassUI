//
//  FullNavigationApp.swift
//  FullNavigation
//
//  Created by Yann Bonafons on 15/03/2026.
//

import SwiftUI
import NavigationLibrary

@main
struct ExampleNavigation​App: App {
    @State var appCoordinator = AppCoordinator(selectedTab: TabItem.home,
                                               possibleTabs: TabItem.allCases)
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $appCoordinator.tabCoordinator.selectedTab) {
                Tab("Home", systemImage: "house", value: TabItem.home.erased()) {
                    NavigationContainerView(sheetCoordinator: appCoordinator.sheetCoordinator,
                                            alertCoordinator: appCoordinator.alertCoordinator,
                                            tabCoordinator: appCoordinator.tabCoordinator) { context in
                        HomeBuilder.createView(
                            with: HomePayload(context: context)
                        )
                    }
                }
                Tab("Settings", systemImage: "gear", value: TabItem.settings.erased()) {
                    NavigationContainerView(sheetCoordinator: appCoordinator.sheetCoordinator,
                                            alertCoordinator: appCoordinator.alertCoordinator,
                                            tabCoordinator: appCoordinator.tabCoordinator) { context in
                        SettingsBuilder.createView(
                            with: SettingsPayload(context: context)
                        )
                    }
                }
            }
            .stackableSheets(coordinator: appCoordinator.sheetCoordinator)
            .alert(coordinator: appCoordinator.alertCoordinator)
        }
    }
}

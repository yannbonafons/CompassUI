//
//  MainTabView.swift
//  CompassUI
//
//  Created by Yann Bonafons on 23/11/2026.
//

import SwiftUI
import CompassUI

/// The app once onboarding is over: a tab bar driven by the `AppCoordinator`.
struct MainTabView: View {
    @Bindable var appCoordinator: AppCoordinator

    var body: some View {
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
        .externalLinks(AppExternalLinkRoute.self,
                       globalContext: appCoordinator.globalContext)
    }
}
